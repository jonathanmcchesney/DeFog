#!/usr/bin/env bash

source /mnt/configs/config.sh
foglampaddress1="${foglampaddress/$'\r'/}"
foglampaddress2="${foglampaddress1/$'\n'/}"

curl -X GET $foglampaddress2/foglamp/category