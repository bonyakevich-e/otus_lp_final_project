#!/bin/bash

function switch_maintance_mode() {
    ssh -o StrictHostKeyChecking=no root@$1 "cd /var/www/nextcloud; sudo -u www-data php occ maintenance:mode --\"$2\""
}

# enable nextcloud Maintenance mode
switch_maintance_mode '192.168.56.20' 'on' || switch_maintance_mode '192.168.56.21' 'on'

# copy nextcloud data directory
rsync -Aavx -e "ssh -o StrictHostKeyChecking=no" root@192.168.56.30:/storage/webserver/nextcloud /backup/nextcloud/nextcloud-dirbkp_`date +"%Y%m%d_%H%M%S"`/

#copy nextcloud database
mysqldump --single-transaction --default-character-set=utf8mb4 -h 192.168.56.40 -u'backup' -p'!Otus2024' nextcloud > /backup/nextcloud/nextcloud-sqlbkp_`date +"%Y%m%d_%H%M%S"`.bak

# disable nextcloud Maintenance mode
switch_maintance_mode '192.168.56.20' 'off' || switch_maintance_mode '192.168.56.21' 'off'
