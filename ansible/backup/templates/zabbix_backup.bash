#!/bin/bash

log_date=`date +"%Y%m%d_%H%M%S"`

mysqldump --single-transaction --default-character-set=utf8mb4 -h 192.168.56.60 -u'backup' -p'!Otus2024' zabbix > /backup/zabbix/zabbix-sqlbkp_${log_date}.bak
