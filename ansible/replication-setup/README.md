replication-setup
=========

Настройка репликации баз данных с сервера dbmaster на сервер dbslave 

Требования
------------

Доступен master сервер баз данных dbmaster. Доступен и сделана начальная настройка slave сервера баз данных dbslave

Переменные
--------------
__mysql_root_password__ - пароль для учётной записи _root_ на master сервере

Пример запуска
----------------
`ansible-playbook playbook.yml --tags="replication-setup"`
