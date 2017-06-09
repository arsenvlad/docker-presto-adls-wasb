# Base image
FROM openjdk:8

# Non interactive shell
ENV DEBIAN_FRONTEND noninteractive

# Environment variables
ENV PRESTO_VERSION 0.167-t.0.4
ENV PRESTO_DIR /opt/presto
ENV PRESTO_DATA_DIR /opt/presto/data

# Update
RUN apt-get update \ 
    && apt-get install -y python uuid-runtime vim

# Download Presto Server
RUN wget http://teradata-presto.s3.amazonaws.com/presto/$PRESTO_VERSION/presto-server-$PRESTO_VERSION.tar.gz \
    && tar xvf presto-server-$PRESTO_VERSION.tar.gz

# Download Presto CLI
RUN wget http://teradata-presto.s3.amazonaws.com/presto/$PRESTO_VERSION/presto-cli-$PRESTO_VERSION-executable.jar -O presto \
    && chmod +x presto      

# Create directories
RUN mkdir -p $PRESTO_DIR \
    && mkdir -p $PRESTO_DATA_DIR \
    && mkdir -p $PRESTO_DIR/etc/catalog \
    && cp -r presto-server-$PRESTO_VERSION/* $PRESTO_DIR \
    && rm -r presto-server-$PRESTO_VERSION \
    && rm presto-server-$PRESTO_VERSION.tar.gz \
    && mv presto $PRESTO_DIR/

# Download specific jars needed for ADLS and WASB and not included in Presto
RUN cd $PRESTO_DIR/plugin/hive-hadoop2 \ 
    && wget http://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar -O commons-lang-2.6.jar \
    && wget http://repo1.maven.org/maven2/org/mortbay/jetty/jetty-util/6.1.26/jetty-util-6.1.26.jar -O jetty-util-6.1.26.jar \
    && wget http://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/5.2.0/azure-storage-5.2.0.jar -O azure-storage-5.2.0.jar \
    && wget http://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar -O azure-data-lake-store-sdk-2.1.5.jar \
    && wget http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha2/hadoop-azure-datalake-3.0.0-alpha2.jar -O hadoop-azure-datalake-3.0.0-alpha2.jar \
    && wget http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.3/hadoop-azure-2.7.3.jar -O hadoop-azure-2.7.3.jar

ADD files /_build/

RUN chmod 777 /_build/create-configs.sh

RUN /_build/create-configs.sh \
    && mv /_build/adls-wasb-site.xml $PRESTO_DIR/etc/catalog/ \
    && mv /_build/motd.txt /etc/motd \
    && rm -rf /_build

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc

WORKDIR $PRESTO_DIR

CMD ["bash"]







