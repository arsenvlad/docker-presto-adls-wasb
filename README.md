# Example Dockerfile for single node Presto with Azure Data Lake Store (ADLS) and Azure Storage Blobs (WASB)

NOTE: To access Azure HDInsight Hive Thrift Service your Docker host VM must be within the same network.

To find the URLs of the HDInsight Hive Thrift Service (i.e. hive.metastore.uri), SSH into the HDInsight cluster and run this grep command:

```echo $(grep -n1 "hive.metastore.uri" /etc/hive/conf/hive-site.xml | grep -o "<value>.*/value>" | sed 's:<value>::g' | sed 's:</value>::g')```

Clone this repo

```git clone https://github.com/arsenvlad/docker-presto-adls-wasb```

Build Docker image

```docker build -t presto-adls-wasb .```

Run Docker container

```docker run -it presto-adls-wasb```

Once inside the docker image, follow the instructions shown in [/etc/motd](files/motd.txt) to configure Presto Hive connector

### Start standalone Hive metastore
* Enter values into env.conf.private file

* Start the Hive Metastore (using embedded Derby)
```docker-compose up --build hive-adls-wasb``` 

* Open bash in this container
```docker exec -it CONTAINER_ID bash```

* Open Hive CLI and point it to itself of metastore
```hive --hiveconf hive.metastore.uris=thrift://localhost:9083```

* Execute simple command to see if it works
```show tables```

* Create table using Azure Storage Blobs
```create external table wasbtable1 (name varchar(255)) location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable1';```

* Create table using Azure Data Lake Store
```create external table adltable4 (name varchar(255)) location 'adl://avdatalake1.azuredatalakestore.net/adltable1';```

* Confirm you can see the tables
```show tables;```