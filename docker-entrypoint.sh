#!/bin/bash

# Set default WWW_DATA_USERID if not exist
# password is limited by 8 characters
: ${UID:=1002}
: ${GID:=1002}

usermod -u $UID php
groupmod -g $GID php

chown -R php:php /var/www/html

exec gosu php "$@"