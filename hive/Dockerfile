FROM sequenceiq/hadoop-docker:2.7.0

ENV HIVE_VERSION=1.2.2
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$HIVE_HOME/bin:$PATH

RUN yum -y install wget

# Download hive
RUN wget https://apache.claz.org/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	tar -zxf ./apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	mv ./apache-hive-${HIVE_VERSION}-bin $HIVE_HOME && \
	rm -f ./apache-hive-${HIVE_VERSION}-bin.tar.gz

# Download specific jars needed for ADLS and WASB and not included in Hive
RUN cd $HIVE_HOME/lib && \
	wget https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.6.0/jackson-core-2.6.0.jar && \
	wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/3.1.0/azure-storage-3.1.0.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.3/hadoop-azure-2.7.3.jar && \
	wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha3/hadoop-azure-datalake-3.0.0-alpha3.jar

# Uninstall JDK 1.7 that was installed in the base image
# Install JDK 1.8 since Azure Data Lake Store JARs are compiled using JDK 1.8
RUN yum erase -y jdk && \ 
	wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm && \
    rpm -i jdk-8u131-linux-x64.rpm && \
    rm jdk-8u131-linux-x64.rpm

EXPOSE 9083

ADD files/metastore-start.sh /etc/metastore-start.sh
RUN chmod +x /etc/metastore-start.sh && sleep 1

CMD /etc/metastore-start.sh
