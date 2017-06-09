### Build Hive docker container
```docker build -t hive .```

### Run container and pass environment variables
```docker run --env-file ../env.conf.private -it hive```

### Container starts metastore service with debug logging and WASB/ADLS credentials configured
```hive --service metastore --hiveconf hive.root.logger=DEBUG,console```

### Start hive cli pointing to the remote metastore
```hive --hiveconf hive.metastore.uris=thrift://localhost:9083```

### Create table using Azure Storage Blobs
```create table wasbtable100 (id int, name varchar(255)) row format delimited fields terminated by ',' stored as textfile location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable100';```

```create external table wasbtable_ext100 (id int, name varchar(255)) row format delimited fields terminated by ',' stored as textfile location 'wasb://test-hive@avdatarepo1.blob.core.windows.net/wasbtable_ext100';```

### Create table using Azure Data Lake Store
```create table adltable100 (id int, name varchar(255)) row format delimited fields terminated by ',' stored as textfile location 'adl://avdatalake1.azuredatalakestore.net/adltable100';```

```create external table adltable100 (id int, name varchar(255)) row format delimited fields terminated by ',' stored as textfile location 'adl://avdatalake1.azuredatalakestore.net/adltable100';```


