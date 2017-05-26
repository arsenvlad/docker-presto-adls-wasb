# Example Dockerfile for single node Presto with Azure Data Lake Store (ADLS) and Azure Storage Blobs (WASB)

IMPORTANT: To access Azure HDInsight Hive Thrift Service your Docker host VM must be within the same network.

To find the URLs of the HDInsight Hive Thrift Service (i.e. hive.metastore.uri), SSH into the HDInsight cluster and run this grep command:

```echo $(grep -n1 "hive.metastore.uri" /etc/hive/conf/hive-site.xml | grep -o "<value>.*/value>" | sed 's:<value>::g' | sed 's:</value>::g')```

Build Docker image

```docker build -t presto-adls-wasb .```

Run Docker container

```docker run -it presto-adls-wasb```

Once inside the docker image follow the instructions shown in /etc/motd to configure Presto Hive connector