#!/bin/bash

log_date=`date +"%Y%m%d_%H%M%S"`

# copy logs
rsync -Aavx -e "ssh -o StrictHostKeyChecking=no" root@192.168.56.70:/var/log/rsyslog/ /backup/logserver/logs-dirbkp_${log_date}/
