#!/usr/bin/env bash

# attempt to make the script collable from anywhere,
# but then Docker Compose will not work...
HERE=$( cd $(dirname "$0") ; pwd -P )
if [ ! -f $HERE/.env ];
then
        echo "ERROR: .env file not found in $HERE"
        echo 'Before continuing, create it from .env.default and edit it:'
        echo '  cp .env.default .env'
        echo '  vi .env'
        echo
        exit 1
fi
source $HERE/.env
if [ "$CUSTOM_CONFIG" = 'NO' ];
then
        echo 'ERROR: .env file was created, but apparently not edited.'
        echo 'If you believe this message is a mistake, please check the beginning of .env'
        echo
        exit 1
fi

if [ "$FORCE" = '1' ];
then
        docker-compose down 2>&1
fi

# get the latest version of PHP Dockerfile
# that will be built by Docker Compose
rm -f docker-php/Dockerfile
wget https://raw.githubusercontent.com/federico-razzoli/php-pdo-pgsql/master/Dockerfile -P $HERE/docker-php

docker-compose up -d

DB_NAME=$DB_NAME DB_USER=$DB_USER DB_PASSWORD=$DB_PASSWORD \
        $HERE/generate-pgpass.sh

# Create a PHP file that defines a PG_CONNECTIONSTRING constant
# containing a usable connectionstring.
mkdir -p $AP_PATH/conf
PHP_DB_CONF_FILE=$AP_PATH/conf/db.php
echo '<?php' > $PHP_DB_CONF_FILE
echo '' >> $PHP_DB_CONF_FILE
echo '// Configure PostgreSQL credentials' >> $PHP_DB_CONF_FILE
echo "define('PG_DSN', \"pgsql:host=db;port=5432;dbname=$DB_NAME;user=$DB_USER;password=$DB_PASSWORD\");" >> $PHP_DB_CONF_FILE
echo '' >> $PHP_DB_CONF_FILE
echo '//EOF' >> $PHP_DB_CONF_FILE

# TEST_DIR contains the files to test that PHP container
# is working ok and can connect to the DB
TEST_DIR=$AP_PATH/test
mkdir -p $TEST_DIR
cp ./test-www/index.html $TEST_DIR
cp ./test-www/php.php $TEST_DIR
cp ./test-www/db.php $TEST_DIR

echo
echo 'The Docker containers and a Docker network are up.'
echo 'You can find some tests to run under /test-www/index.html'
echo 'You may need a couple of minutes before running them.'
echo ''
echo 'To shutdown the containers:'
echo '  docker-compose down'
echo
echo 'To recreate the containers and copy the files again:'
echo '  FORCE=1 ./up'
echo


