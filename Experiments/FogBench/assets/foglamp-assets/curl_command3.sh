#!/usr/bin/env bash

source /mnt/configs/config.sh
foglampaddress1="${foglampaddress/$'\r'/}"
foglampaddress2="${foglampaddress1/$'\n'/}"

curl -s $foglampaddress2/foglamp/audit?limit=40