#!/bin/bash
############ Setup
ENSEMBLE_SQL_STRUCTURE_SOURCE=https://ftp.ensembl.org/pub/release-100/mysql/homo_sapiens_core_100_38/homo_sapiens_core_100_38.sql.gz
ENSEMBLE_TABLE_SQL_DATA_SOURCE_DIR="https://ftp.ensembl.org/pub/current_mysql/homo_sapiens_core_109_38"
DATABASE_NAME=homo_sapiens_core_109_38
docker_exec_db_container() {
    docker exec ensemble_mysql /bin/bash -c "${1}"
}
run_sql_root_command() {
    docker_exec_db_container "/bin/mysql -uroot -pensemble -e ${1@Q}"
}

run_sql_database_command() {
    docker_exec_db_container "/bin/mysql -uroot -pensemble ${DATABASE_NAME} -e ${1@Q}"
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
echo "Download data from $ENSEMBLE_SQL_STRUCTURE_SOURCE"
docker_exec_db_container "curl -o /import/data.sql.gz ${ENSEMBLE_DATA_SOURCE}"
echo "Extract data"
docker_exec_db_container "gzip -d /import/data.sql.gz"
# create database if not exists
echo "Create database ${DATABASE_NAME}"
run_sql_root_command "CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};"
# import data
echo "import data"
docker_exec_db_container "/bin/mysql -uroot -pensemble ${DATABASE_NAME} < /import/data.sql"
echo "show all tables to verifiy data exists:"
run_sql_database_command "SHOW TABLES;"

# TODO we now need to load all txt files in $ENSEMBLE_TABLE_SQL_DATA_SOURCE_DIR

echo "!TODO!: Data files from ${ENSEMBLE_TABLE_SQL_DATA_SOURCE_DIR} are not laoded yet. "
