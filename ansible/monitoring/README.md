monitoring
=========

Настройка сервера для мониторинга удалённых хостов. Устанавливает и настраивает ПО __Zabbix__. 

Переменные
----------
__mysql_root_password__ - пароль, который будет установлен для учётной записи _root_ в MySQL

__zabbix_user_name__ - имя учётной записи, которая будет создана для доступа к БД zabbix

__zabbix_user_password__ - пароль, который должен быть установлен для _zabbix_user_name_

__backup_user_name__ - имя учётной записи, которая будет создана для выполнения бэкапов баз данных

__backup_user_password__ - пароль, который должен быть установлен для _backup_user_password_

Пример запуска
----------------

`ansible-playbook playbook.yml --tags="monitoring"`
