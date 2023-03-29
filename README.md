# dzd-michail-ensemble-r-demo

This is just a little debug script. If you came here by accident and you dont know what this all means you probablly wont need it.

We start a sql database and try to load the enemble data for [homo_sapiens_core_109_38](https://ftp.ensembl.org/pub/current_mysql/homo_sapiens_core_109_38)

based on 

https://www.ensembl.org/info/docs/webcode/mirror/install/ensembl-data.html


State: uncomplete: Only the data structure is created atm

## Run on linux bash

requierments:
* curl
* docker with `docker compose`
    

`git clone git@github.com:motey/dzd-michail-ensemble-r-demo.git`

`cd dzd-michail-ensemble-r-demo`

`./run.sh`


The ensemble sql database with data from  
`https://ftp.ensembl.org/pub/release-100/mysql/homo_sapiens_core_100_38/homo_sapiens_core_100_38.sql.gz`  
will be available at  

`localhost:3306` via sql user `root` and password `ensemble`  

If you want to a different dataset change the varibale [`ENSEMBLE_DATA_SOURCE`](https://github.com/motey/dzd-michail-ensemble-r-demo/blob/main/run.sh#L3)