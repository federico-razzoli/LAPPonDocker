#!/usr/bin/env bash


# Validate input
if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ];
then
        echo 'ERROR: all the following variables must have a value - DB_NAME, DB_USER, DB_PASSWORD.'
        echo 'Usage example:'
        echo '  DB_NAME=my_db DB_USER=i DB_PASSWORD=secret ./generate-pgpass.sh'
        echo
        exit 1
fi


# Create .pgpass and an alias in .bashrc, so root can connect to PostgreSQL
# by just typing "pg".
docker exec -ti apachephppostgresql_db_1 sh -c "echo '#hostname:port:database:username:password'       > /root/.pgpass"
docker exec -ti apachephppostgresql_db_1 sh -c "echo 'localhost:5432:$DB_NAME:$DB_USER:$DB_PASSWORD'  >> /root/.pgpass"
docker exec -ti apachephppostgresql_db_1 sh -c "chmod 0600 /root/.pgpass"
PSQL="psql -U $DB_USER -d $DB_NAME"
docker exec -ti apachephppostgresql_db_1 sh -c "echo \"alias pg='$PSQL'\" >> /root/.bashrc"
PSQL=''
docker exec -ti apachephppostgresql_db_1 sh -c "chmod 0644 /root/.bashrc"

echo '.pgpass and "pg" alias generated'


