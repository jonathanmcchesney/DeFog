/*
 * FogLAMP storage service client
 *
 * Copyright (c) 2018 OSIsoft, LLC
 *
 * Released under the Apache 2.0 Licence
 *
 * Author: Mark Riddoch, Massimiliano Pinto
 */
#include <reading.h>
#include <ctime>
#include <string>
#include <sstream>
#include <iostream>
#include <uuid/uuid.h>
#include <time.h>

using namespace std;

std::vector<std::string> Reading::m_dateTypes = {
	DEFAULT_DATE_TIME_FORMAT,
	COMBINED_DATE_STANDARD_FORMAT,
	ISO8601_DATE_TIME_FORMAT
};

/**
 * Reading constructor
 *
 * A reading is a container for the values related to a single asset.
 * Each actual datavalue that relates to that asset is held within an
 * instance of a Datapoint class.
 */
Reading::Reading(const string& asset, Datapoint *value) : m_asset(asset)
{
uuid_t	uuid;
char	uuid_str[37];

	m_values.push_back(value);
	uuid_generate_time_safe(uuid);
	uuid_unparse_lower(uuid, uuid_str);
	m_uuid = string(uuid_str);
	// Store seconds and microseconds
	gettimeofday(&m_timestamp, NULL);
	// Initialise m_userTimestamp
	m_userTimestamp = m_timestamp;
}

/**
 * Reading constructor
 *
 * A reading is a container for the values related to a single asset.
 * Each actual datavalue that relates to that asset is held within an
 * instance of a Datapoint class.
 */
Reading::Reading(const string& asset, vector<Datapoint *> values) : m_asset(asset)
{
uuid_t	uuid;
char	uuid_str[37];

	for (auto it = values.cbegin(); it != values.cend(); it++)
	{
		m_values.push_back(*it);
	}
	uuid_generate_time_safe(uuid);
	uuid_unparse_lower(uuid, uuid_str);
	m_uuid = string(uuid_str);
	// Store seconds and microseconds
	gettimeofday(&m_timestamp, NULL);
	// Initialise m_userTimestamp
	m_userTimestamp = m_timestamp;
}

/**
 * Reading constructor
 *
 * A reading is a container for the values related to a single asset.
 * Each actual datavalue that relates to that asset is held within an
 * instance of a Datapoint class.
 */
Reading::Reading(const string& asset, vector<Datapoint *> values, const string& ts) : m_asset(asset)
{
uuid_t	uuid;
char	uuid_str[37];

	for (auto it = values.cbegin(); it != values.cend(); it++)
	{
		m_values.push_back(*it);
	}
	uuid_generate_time_safe(uuid);
	uuid_unparse_lower(uuid, uuid_str);
	m_uuid = string(uuid_str);
	struct tm tm;
	strptime(ts.c_str(), COMBINED_DATE_STANDARD_FORMAT, &tm);
	m_timestamp.tv_sec = mktime(&tm);
	const char *ptr = ts.c_str();
	while (*ptr && *ptr != '.')
		ptr++;
	if (ptr)
	{
		ptr++;
		m_timestamp.tv_usec = strtol(ptr, NULL, 10);
	}
	// We now need to allow for the timezone difference as mktime is returning
	// In the local timezone
	time_t	now = time(NULL);
	struct tm local = *localtime(&now);
	struct tm utc = *gmtime(&now);

	m_timestamp.tv_sec -= 3600 * (local.tm_hour - utc.tm_hour);
	// Initialise m_userTimestamp
	m_userTimestamp = m_timestamp;
}

/**
 * Reading copy constructor
 */
Reading::Reading(const Reading& orig) : m_asset(orig.m_asset),
	m_timestamp(orig.m_timestamp), m_uuid(orig.m_uuid),
	m_userTimestamp(orig.m_userTimestamp),
	m_has_id(orig.m_has_id), m_id(orig.m_id)
{
	for (auto it = orig.m_values.cbegin(); it != orig.m_values.cend(); it++)
	{
		m_values.push_back(new Datapoint(**it));
	}
}

/**
 * Destructor for Reading class
 */
Reading::~Reading()
{
	for (auto it = m_values.cbegin(); it != m_values.cend(); it++)
	{
		delete(*it);
	}
}

/**
 * Remove all data points for Reading class
 */
void Reading::removeAllDatapoints()
{
	for (auto it = m_values.cbegin(); it != m_values.cend(); it++)
	{
		delete(*it);
	}
	m_values.clear();
}

/**
 * Add another data point to an asset reading
 */
void Reading::addDatapoint(Datapoint *value)
{
	m_values.push_back(value);
}

/**
 * Return the asset reading as a JSON structure encoded in a
 * C++ string.
 */
string Reading::toJSON() const
{
ostringstream convert;

	convert << "{ \"asset_code\" : \"";
	convert << m_asset;
	convert << "\", \"read_key\" : \"";
	convert << m_uuid;
	convert << "\", \"user_ts\" : \"";

	// Add date_time with microseconds + timezone UTC:
	// YYYY-MM-DD HH24:MM:SS.MS+00:00
	convert << Reading::getAssetDateUserTime(FMT_DEFAULT) << "+00:00";
	convert << "\", \"ts\" : \"";

	// Add date_time with microseconds + timezone UTC:
	// YYYY-MM-DD HH24:MM:SS.MS+00:00
	convert << Reading::getAssetDateTime(FMT_DEFAULT) << "+00:00";

	// Add values
	convert << "\", \"reading\" : { ";
	for (auto it = m_values.cbegin(); it != m_values.cend(); it++)
	{
		if (it != m_values.cbegin())
		{
			convert << ", ";
		}
		convert << (*it)->toJSONProperty();
	}
	convert << " } }";

	return convert.str();
}

/**
 * Return a formatted   m_timestamp DataTime in UTC
 * @param dateFormat    Format: FMT_DEFAULT or FMT_STANDARD
 * @return              The formatted datetime string
 */
const string Reading::getAssetDateTime(readingTimeFormat dateFormat, bool addMS) const
{
char date_time[DATE_TIME_BUFFER_LEN];
char micro_s[10];
ostringstream assetTime;

        // Populate tm structure
        const struct tm *timeinfo = std::gmtime(&(m_timestamp.tv_sec));

        /**
         * Build date_time with format YYYY-MM-DD HH24:MM:SS.MS+00:00
         * this is same as Python3:
         * datetime.datetime.now(tz=datetime.timezone.utc)
         */

        // Create datetime with seconds
        std::strftime(date_time, sizeof(date_time),
		      m_dateTypes[dateFormat].c_str(),
                      timeinfo);

	if (dateFormat != FMT_ISO8601 && addMS)
	{
		// Add microseconds
		snprintf(micro_s,
			 sizeof(micro_s),
			 ".%06lu",
			 m_timestamp.tv_usec);

		// Add date_time + microseconds
		assetTime << date_time << micro_s;

		return assetTime.str();
	}
	else
	{
		return string(date_time);
	}

}

/**
 * Return a formatted   m_userTimestamp DataTime in UTC
 * @param dateFormat    Format: FMT_DEFAULT or FMT_STANDARD
 * @return              The formatted datetime string
 */
const string Reading::getAssetDateUserTime(readingTimeFormat dateFormat, bool addMS) const
{
char date_time[DATE_TIME_BUFFER_LEN];
char micro_s[10];
ostringstream assetTime;

        // Populate tm structure
        const struct tm *timeinfo = std::gmtime(&(m_userTimestamp.tv_sec));

        /**
         * Build date_time with format YYYY-MM-DD HH24:MM:SS.MS+00:00
         * this is same as Python3:
         * datetime.datetime.now(tz=datetime.timezone.utc)
         */

        // Create datetime with seconds
        std::strftime(date_time, sizeof(date_time),
		      m_dateTypes[dateFormat].c_str(),
                      timeinfo);

	if (dateFormat != FMT_ISO8601 && addMS)
	{
		// Add microseconds
		snprintf(micro_s,
			 sizeof(micro_s),
			 ".%06lu",
			 m_userTimestamp.tv_usec);

		// Add date_time + microseconds
		assetTime << date_time << micro_s;

		return assetTime.str();
	}
	else
	{
		return string(date_time);
	}

}
