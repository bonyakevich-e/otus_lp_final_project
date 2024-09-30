### ТЕМА ПРОЕКТА: "Реализация отказоустойчивого веб-сервиса с помощью системы оркестрации Ansible"

#### СХЕМА ПРОЕКТА:

![Схема (3)](https://github.com/user-attachments/assets/32968ef9-183d-442b-9143-2b5593e6db60)

#### ОПИСАНИЕ: 

В качестве отказустойчивого веб-сервиса используется облачный сервис хранения данных __Nextcloud__. 

__Для реализации проекта используются следующие хосты:__
1. `balancer` - frontend-сервер, балансирует web запросы между backend-серверами webserver1 и webserver2. В качестве балансировщика выступает HAProxy;
2. `webserver1` - первый backend-сервер. В качестве веб-сервера выступает Apache2 + mod_php;
3. `webserver2` - второй backend-сервер. В качестве веб-сервера выступает Apache2 + mod_php;
4. `dbmaster` - основной сервер базы данных. В качестве СУБД выступает MariaDB 10.6;
5. `dbslave` - реплика основного сервера базы данных. В качестве СУБД выступает MariaDB 10.6;
6. `storage` - сервер для хранения файловых данных веб-сервиса Nextcloud. Для монтирования каталога с данными на backend-сервера используется NFS;
7. `monitoring` - сервер для мониторинга узлов сети. В качестве сервиса мониторинга выступает Zabbix 6.0;
8. `logserver` - сервер для сбора логов. В качестве сборщика логов используется rsyslog;
9. `backup` - сервер для хранения бэкапов. На сервере размещены скрипты для автоматического сбора бэкапов базы данных Nextcloud, файловых данных Nextcloud, базы данных Zabbix и логов.

Стенд собирается с помощью системы оркестрации __Ansible__. Установка выше указанных серверов и настройка отказоустойчивого веб-сервиса разбита на роли.

__Краткое описание ролей:__
1. `balancer` - настройка frontend-сервера 'balancer';
2. `webserver1` - настройка backend-сервера 'webserver1';
3. `webserver2` - настройка backend-сервера 'webserver2';
4. `dbmaster` - настройка сервера 'dbmaster' для базы данных;
5. `dbslave` - настройка сервера 'dbslave' для реплики базы данных;
6. `replication-setup` - настройка репликации базы данных с 'dbmaster' на 'dbslave';
7. `storage` - настройка сервера 'storage' для хранения файловых данных;
8. `nextcloud-setup` - установка чистого сервиса Nextcloud;
9. `nextcloud-restore` - восстановление сервиса Nextcloud из бэкапов;
10. `monitoring` - настройка сервера мониторинга 'monitoring';
11. `zabbix-restore` - восстановление сервиса Zabbix из бэкапов;
12. `logserver` - настройка сервера сбора логов 'logserver';
13. `backup` - настройка бэкап-сервера 'backup'

При выходе из строя какого-либо сервиса в схеме восстановление выполняется запуском требуемой роли. 

__Процедура восстановления сервисов__
1. Восстановление frontend-сервера `balancer`:
```console
ansible-playbook playbook.yml --tags="balancer" --ask-vault-pass
```
2. Восстановление backend-сервера `webserver1`:
```console
ansible-playbook playbook.yml --tags="webserver1"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_webserver1"
```
3. Восстановление backend-сервера `webserver2`:
```console
ansible-playbook playbook.yml --tags="webserver2"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_webserver2"
```
4. Восстановление базы данных `dbmaster`:
```console
ansible-playbook playbook.yml --tags="dbmaster"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_dbmaster"
```
```console
ansible-playbook playbook.yml -e "backup_date=20240920_132654" --tags="nextcloud-restore"
```
здесь `backup_date=20240920_132654` - дата бэкапа (см. список бэкапов на бэкап-сервере) 

После восстановление главной базы данных из бэкапов нужно пересоздать реплику (см. ниже 'восстановление базы данных dbslave')

5. Восстановление базы данных `dbslave`:
```console
ansible-playbook playbook.yml --tags="dbslave"
```
```console
ansible-playbook playbook.yml --tags="replication-setup"
```
6. Восстановление файлового хранилища `storage`:
```console
ansible-playbook playbook.yml --tags="storage"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_storage"
```
```console
ansible-playbook playbook.yml -e "backup_date=20240924_183637" --tags="nextcloud-restore"
```
здесь `backup_date=20240920_132654` - дата бэкапа (см. список бэкапов на бэкап-сервере)

После восстановление главной базы данных из бэкапов нужно пересоздать реплику (см. выше 'восстановление базы данных dbslave'). Так как при восстановлении файлов данных сервиса Nextcloud мы также восстанавливаем master базу данных для консистентности между базой данных и файловым хранилищем.

7. Восстановление сервера мониторинга `monitoring`
```console
ansible-playbook playbook.yml --tags="monitoring"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_monitoring"
```
```console
ansible-playbook playbook.yml -e "backup_date=20240924_050001" --tags="zabbix-restore"
```
здесь `backup_date=20240920_132654` - дата бэкапа (см. список бэкапов на бэкап-сервере)

8. Восстановление сервера логирования `logserver`:
```console
ansible-playbook playbook.yml --tags="logserver"
```
```console
ansible-playbook playbook.yml --tags="fetch_backup_ssh_key,deploy_backup_key_to_logserver"
```
При восстановление сервера логирования логи с бэкапа не восстанавливаются. Утерянные логи можно посмотреть в бэкапе.

9. Восстановление бэкап-сервера `backup`:
```console
ansible-playbook playbook.yml --tags="backup"
```
