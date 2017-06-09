### Build Hive docker container
```docker build . -t hive```

### Run container and pass environment variables
```docker run --env-file ../env.conf.private -it hive```

### Container starts metastore service with debug logging and WASB/ADLS credentials configured
```hive --service metastore --hiveconf hive.root.logger=DEBUG,console```

### Start hive cli pointing to the remote metastore
```hive --hiveconf hive.metastore.uris=thrift://localhost:9083```

### Create table using Azure Storage Blobs
```create table wasbtable1 (name varchar(255)) location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable1';```
```create table wasbtable2 (name varchar(255)) location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable2';```
```create table wasbtable3 (name varchar(255)) location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable3';```
```create external table wasbtable4 (name varchar(255)) location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable4';```

### Create table using Azure Data Lake Store
```create external table adltable4 (name varchar(255)) location 'adl://avdatalake1.azuredatalakestore.net/adltable1';```


