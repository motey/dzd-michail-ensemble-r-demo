# dzd-michail-ensemble-r-demo


## Run on linux bash

requierments:
    curl
    docker and docker-compose
    

`git clone git@github.com:motey/dzd-michail-ensemble-r-demo.git`

`cd dzd-michail-ensemble-r-demo`

`./run.sh`


The ensamble with data from `https://ftp.ensembl.org/pub/release-100/mysql/homo_sapiens_core_100_38/homo_sapiens_core_100_38.sql.gz` database will be available at  
`localhost:3306` via sql user `root` and password `ensemble`

If you want to a different dataset change the varibale [`ENSEMBLE_DATA_SOURCE`](https://github.com/motey/dzd-michail-ensemble-r-demo/blob/main/run.sh#L3)