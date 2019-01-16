# -*- coding: utf-8 -*-

# FOGLAMP_BEGIN
# See: http://foglamp.readthedocs.io/
# FOGLAMP_END

import datetime
from aiohttp import web
from foglamp.common.service_record import ServiceRecord
from foglamp.services.core.service_registry.service_registry import ServiceRegistry
from foglamp.common.storage_client.payload_builder import PayloadBuilder
from foglamp.common.configuration_manager import ConfigurationManager
from foglamp.services.core import server
from foglamp.services.core import connect
from foglamp.services.core.scheduler.entities import StartUpSchedule
from foglamp.common.storage_client.exceptions import StorageServerError
from foglamp.common import utils
from foglamp.services.core.api import utils as apiutils

__author__ = "Mark Riddoch, Ashwin Gopalakrishnan, Amarendra K Sinha"
__copyright__ = "Copyright (c) 2018 OSIsoft, LLC"
__license__ = "Apache 2.0"
__version__ = "${VERSION}"

_help = """
    -------------------------------------------------------------------------------
    | GET POST            | /foglamp/service                                      |
    -------------------------------------------------------------------------------
"""


#################################
#  Service
#################################


def get_service_records():
    sr_list = list()
    for service_record in ServiceRegistry.all():
        sr_list.append(
            {
                'name': service_record._name,
                'type': service_record._type,
                'address': service_record._address,
                'management_port': service_record._management_port,
                'service_port': service_record._port,
                'protocol': service_record._protocol,
                'status': ServiceRecord.Status(int(service_record._status)).name.lower()
            })
    recs = {'services': sr_list}
    return recs


async def get_health(request):
    """
    Args:
        request:

    Returns:
            health of all registered services

    :Example:
            curl -X GET http://localhost:8081/foglamp/service
    """
    response = get_service_records()
    return web.json_response(response)


async def add_service(request):
    """
    Create a new service to run a specific plugin

    :Example:
             curl -X POST http://localhost:8081/foglamp/service -d '{"name": "DHT 11", "plugin": "dht11", "type": "south", "enabled": true}'
    """

    try:
        data = await request.json()
        if not isinstance(data, dict):
            raise ValueError('Data payload must be a dictionary')

        name = data.get('name', None)
        plugin = data.get('plugin', None)
        service_type = data.get('type', None)
        enabled = data.get('enabled', None)

        if name is None:
            raise web.HTTPBadRequest(reason='Missing name property in payload.')
        if plugin is None:
            raise web.HTTPBadRequest(reason='Missing plugin property in payload.')
        if service_type is None:
            raise web.HTTPBadRequest(reason='Missing type property in payload.')
        if utils.check_reserved(name) is False:
            raise web.HTTPBadRequest(reason='Invalid name property in payload.')
        if utils.check_reserved(plugin) is False:
            raise web.HTTPBadRequest(reason='Invalid plugin property in payload.')

        service_type = str(service_type).lower()
        if service_type == 'north':
            raise web.HTTPNotAcceptable(reason='north type is not supported for the time being.')
        if service_type not in ['south']:
            raise web.HTTPBadRequest(reason='Only south type is supported.')
        if enabled is not None:
            if enabled not in ['true', 'false', True, False]:
                raise web.HTTPBadRequest(reason='Only "true", "false", true, false'
                                                ' are allowed for value of enabled.')
        is_enabled = True if ((type(enabled) is str and enabled.lower() in ['true']) or (
            (type(enabled) is bool and enabled is True))) else False

        # Check if a valid plugin has been provided
        try:
            # "plugin_module_path" is fixed by design. It is MANDATORY to keep the plugin in the exactly similar named
            # folder, within the plugin_module_path.
            # if multiple plugin with same name are found, then python plugin import will be tried first
            plugin_module_path = "foglamp.plugins.south" if service_type == 'south' else "foglamp.plugins.north"
            import_file_name = "{path}.{dir}.{file}".format(path=plugin_module_path, dir=plugin, file=plugin)
            _plugin = __import__(import_file_name, fromlist=[''])

            script = '["services/south"]' if service_type == 'south' else '["services/north"]'
            # Fetch configuration from the configuration defined in the plugin
            plugin_info = _plugin.plugin_info()
            plugin_config = plugin_info['config']
            process_name = 'south'
        except ImportError as ex:
            # Checking for C-type plugins
            script = '["services/south_c"]' if service_type == 'south' else '["services/north_c"]'
            plugin_info = apiutils.get_plugin_info(plugin)
            plugin_config = plugin_info['config']
            process_name = 'south_c'
            if not plugin_config:
                raise web.HTTPNotFound(reason='Plugin "{}" import problem from path "{}". {}'.format(plugin, plugin_module_path, str(ex)))
        except Exception as ex:
            raise web.HTTPInternalServerError(reason='Failed to fetch plugin configuration. {}'.format(str(ex)))

        storage = connect.get_storage_async()

        # Check that the process name is not already registered
        count = await check_scheduled_processes(storage, process_name)
        if count == 0:
            # Now first create the scheduled process entry for the new service
            payload = PayloadBuilder().INSERT(name=process_name, script=script).payload()
            try:
                res = await storage.insert_into_tbl("scheduled_processes", payload)
            except StorageServerError as ex:
                err_response = ex.error
                raise web.HTTPInternalServerError(reason='Failed to created scheduled process. {}'.format(err_response))
            except Exception as ins_ex:
                raise web.HTTPInternalServerError(reason='Failed to created scheduled process. {}'.format(str(ins_ex)))

        # Check that the schedule name is not already registered
        count = await check_schedules(storage, name)
        if count != 0:
            raise web.HTTPBadRequest(reason='A schedule with that name already exists')

        # If successful then create a configuration entry from plugin configuration
        try:
            # Create a configuration category from the configuration defined in the plugin
            category_desc = plugin_config['plugin']['description']
            config_mgr = ConfigurationManager(storage)
            await config_mgr.create_category(category_name=name,
                                             category_description=category_desc,
                                             category_value=plugin_config,
                                             keep_original_items=True)
            # Create the parent category for all South services
            await config_mgr.create_category("South", {}, "South microservices", True)
            await config_mgr.create_child_category("South", [name])
        except Exception as ex:
            await revert_configuration(storage, name)  # Revert configuration entry
            await revert_parent_child_configuration(storage, name)
            raise web.HTTPInternalServerError(reason='Failed to create plugin configuration. {}'.format(str(ex)))

        # If all successful then lastly add a schedule to run the new service at startup
        try:
            schedule = StartUpSchedule()
            schedule.name = name
            schedule.process_name = process_name
            schedule.repeat = datetime.timedelta(0)
            schedule.exclusive = True
            #  if "enabled" is supplied, it gets activated in save_schedule() via is_enabled flag
            schedule.enabled = False

            # Save schedule
            await server.Server.scheduler.save_schedule(schedule, is_enabled)
            schedule = await server.Server.scheduler.get_schedule_by_name(name)
        except StorageServerError as ex:
            await revert_configuration(storage, name)  # Revert configuration entry
            await revert_parent_child_configuration(storage, name)
            raise web.HTTPInternalServerError(reason='Failed to created schedule. {}'.format(ex.error))
        except Exception as ins_ex:
            await revert_configuration(storage, name)  # Revert configuration entry
            await revert_parent_child_configuration(storage, name)
            raise web.HTTPInternalServerError(reason='Failed to created schedule. {}'.format(str(ins_ex)))

        return web.json_response({'name': name, 'id': str(schedule.schedule_id)})

    except ValueError as ex:
        raise web.HTTPNotFound(reason=str(ex))


async def check_scheduled_processes(storage, process_name):
    payload = PayloadBuilder().SELECT("name").WHERE(['name', '=', process_name]).payload()
    result = await storage.query_tbl_with_payload('scheduled_processes', payload)
    return result['count']


async def check_schedules(storage, schedule_name):
    payload = PayloadBuilder().SELECT("schedule_name").WHERE(['schedule_name', '=', schedule_name]).payload()
    result = await storage.query_tbl_with_payload('schedules', payload)
    return result['count']


async def revert_configuration(storage, key):
    payload = PayloadBuilder().WHERE(['key', '=', key]).payload()
    await storage.delete_from_tbl('configuration', payload)


async def revert_parent_child_configuration(storage, key):
    payload = PayloadBuilder().WHERE(['parent', '=', "South"]).AND_WHERE(['child', '=', key]).payload()
    await storage.delete_from_tbl('category_children', payload)
