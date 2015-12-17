#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

if [ -n "$MARIADB_DATABASE" ]; then
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE"
    echo "=> Database $MARIADB_DATABASE created!"
fi

if [ -n "$MARIADB_USER" ]; then
    PASSWORD=${MARIADB_USER_PASSWORD:-$(pwgen -s 12 1)}

    mysql -uroot -e "CREATE USER '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD'"

    if [ -n "$MARIADB_DATABASE" ]; then
        mysql -uroot -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION"
    fi
    echo "=> User $MARIADB_USER created!"
fi

mysqladmin -uroot shutdown
