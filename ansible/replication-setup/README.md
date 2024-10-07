replication-setup
=========

Настройка репликации баз данных с сервера __dbmaster__ на сервер __dbslave__

Требования
------------

Доступен master сервер баз данных __dbmaster__. Доступен и сделана начальная настройка slave сервера баз данных __dbslave__

Переменные
--------------
__mysql_root_password__ - пароль для учётной записи _root_ на master сервере

Пример запуска
----------------
`ansible-playbook playbook.yml --tags="replication-setup"`
