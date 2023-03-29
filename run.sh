#!/bin/bash
############ Setup
ENSEMBLE_DATA_SOURCE=https://ftp.ensembl.org/pub/release-100/mysql/homo_sapiens_core_100_38/homo_sapiens_core_100_38.sql.gz
DATABASE_NAME=homo_sapiens_core_109_38
docker_exec_db_container() {
    docker exec ensemble_mysql /bin/bash -c "${1}"
}
run_sql_command() {
    docker_exec_db_container "/bin/mysql -uroot -pensemble -e ${1@Q}"
}

reset_db() {
    # reset DB for clean/reproducable start
    docker compose -f database/docker-compose.yml down
    # Delete old data
    echo "Delete old data. Maybe we need a sudo password input here..."
    sudo rm -rf database/mysql
    sudo rm -rf database/import
}

wait_for_db_boot() {
    echo -ne "Wait for db booting"
    while [ "$(docker inspect -f {{.State.Health.Status}} $1)" != "healthy" ]; do
        echo -ne "."
        sleep 1
    done
    echo ""
}

############# Script
reset_db
# Start database via docker-compose
docker compose -f database/docker-compose.yml up -d
wait_for_db_boot ensemble_mysql
# Download, extract ensemble data and move it into db import dir
echo "Download data from $ENSEMBLE_DATA_SOURCE"
docker_exec_db_container "curl -o /import/homo_sapiens_core_100_38.sql.gz ${ENSEMBLE_DATA_SOURCE}"
echo "Extract data"
docker_exec_db_container "gzip -d /import/homo_sapiens_core_100_38.sql.gz"
# create database if not exists
echo "Create database ${DATABASE_NAME}"
run_sql_command "CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};"
