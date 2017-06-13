# Base image
FROM openjdk:8

# Non interactive shell
ENV DEBIAN_FRONTEND noninteractive

# Environment variables
ENV PRESTO_VERSION 0.178
ENV PRESTO_DIR /opt/presto
ENV PRESTO_DATA_DIR /opt/presto/data

# Update
RUN apt-get update && \ 
    apt-get install -y python uuid-runtime vim less

# Download Presto
RUN curl -s -O https://repo1.maven.org/maven2/com/facebook/presto/presto-server/$PRESTO_VERSION/presto-server-$PRESTO_VERSION.tar.gz && \
    tar xvf presto-server-$PRESTO_VERSION.tar.gz

# Download Presto CLI
RUN curl -s -O https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/$PRESTO_VERSION/presto-cli-$PRESTO_VERSION-executable.jar && \
    mv presto-cli-$PRESTO_VERSION-executable.jar presto && \
    chmod +x presto      
    
# Create directories
RUN mkdir -p $PRESTO_DIR && \
    mkdir -p $PRESTO_DATA_DIR && \
    mkdir -p $PRESTO_DIR/etc/catalog && \
    cp -r presto-server-$PRESTO_VERSION/* $PRESTO_DIR && \
    rm -r presto-server-$PRESTO_VERSION && \
    rm presto-server-$PRESTO_VERSION.tar.gz && \
    mv presto $PRESTO_DIR/

# Download specific jars needed for ADLS and WASB and not included in Presto
# hadoop-azure-2.7.3.jar depends on azure-storage-2.0.0.jar since it implements the startCopyFromBlob which was removed from later versions
RUN cd $PRESTO_DIR/plugin/hive-hadoop2 && \ 
    curl -O http://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar && \
    curl -O http://repo1.maven.org/maven2/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar && \
    curl -O http://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/2.0.0/azure-storage-2.0.0.jar && \
    curl -O http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.3/hadoop-azure-2.7.3.jar && \
    curl -O http://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar && \
    curl -O http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha3/hadoop-azure-datalake-3.0.0-alpha3.jar    

ADD files /_build/

RUN chmod +x /_build/create-configs.sh && sleep 1 && \
    /_build/create-configs.sh && \
    mv /_build/adls-wasb-site.xml $PRESTO_DIR/etc/catalog/ && \
    mv /_build/presto-start.sh /etc/presto-start.sh && \
    chmod +x /etc/presto-start.sh && sleep 1 && \
    mv /_build/motd.txt /etc/motd && \
    rm -rf /_build

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc

WORKDIR $PRESTO_DIR

CMD /etc/presto-start.sh







