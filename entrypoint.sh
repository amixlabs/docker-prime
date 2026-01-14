#!/bin/bash
set -e

APP_USER=user
APP_GROUP=user

if ! getent group ${APP_GROUP} >/dev/null; then
    groupadd ${APP_GROUP}
fi

if ! getent passwd ${APP_USER} >/dev/null 2>&1; then
    useradd -m -s /bin/bash -g ${APP_GROUP} ${APP_USER}
fi

if [[ -n "$LOCAL_USER_ID" && "$LOCAL_USER_ID" -ne 0 ]]; then
    LOCAL_GROUP_ID=${LOCAL_GROUP_ID:-$LOCAL_USER_ID}

    export HOME=/home/${APP_USER}

    usermod --uid "$LOCAL_USER_ID" ${APP_USER}
    groupmod --gid "$LOCAL_GROUP_ID" ${APP_USER}
    chown -R ${APP_USER}:${APP_GROUP} /home/${APP_USER} /var/log/apache2
    
    if [[ "$1" == "apachectl" ]]; then
        rm -rf /run/apache2/*
        chown -R www-data:www-data /app/{ses,log}

        [ -f /etc/apache2/conf-available/compression.conf ] && a2enconf compression
        [ -f /etc/apache2/sites-available/prime.conf ] && a2ensite prime

        mkdir -p /run/php
        chown www-data:www-data /run/php

        php-fpm8.1 --daemonize

        exec "$@"
    else
        exec gosu ${APP_USER} "$@"
    fi
fi

exec "$@"