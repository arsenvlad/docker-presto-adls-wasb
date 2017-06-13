#!/bin/bash

export PRESTO_DIR=/opt/presto

# Update config file with credentials for WASB and ADLS
config=$PRESTO_DIR/etc/catalog/adls-wasb-site.xml

sed -i -e "s/ADLS_TENANT_ID/${ADLS_TENANT_ID}/g" $config
sed -i -e "s/ADLS_CLIENT_ID/${ADLS_CLIENT_ID}/g" $config
sed -i -e "s#ADLS_CLIENT_SECRET#${ADLS_CLIENT_SECRET}#g" $config

sed -i -e "s/AZURE_STORAGE_ACCOUNT_NAME/${AZURE_STORAGE_ACCOUNT_NAME}/g" $config
sed -i -e "s#AZURE_STORAGE_ACCOUNT_KEY#${AZURE_STORAGE_ACCOUNT_KEY}#g" $config

# Create additional catalogs...

# Azure CosmosDB with MongoAPI
if [ -n "$MONGODB_SEEDS" ]; then
cat > $PRESTO_DIR/etc/catalog/cosmosdb.properties <<EOF
connector.name=mongodb
mongodb.seeds=$MONGODB_SEEDS
mongodb.credentials=$MONGODB_CREDENTIALS
mongodb.ssl.enabled=$MONGODB_SSL_ENABLED
EOF
fi

# Azure SQL Database
if [ -n "$SQLSERVER_JDBC_URL" ]; then
cat > $PRESTO_DIR/etc/catalog/azuresql.properties <<EOF
connector.name=sqlserver
connection-url=$SQLSERVER_JDBC_URL
connection-user=$SQLSERVER_USERNAME
connection-password=$SQLSERVER_PASSWORD
EOF
fi

# MySQL 
if [ -n "$MYSQL_JDBC_URL" ]; then
cat > $PRESTO_DIR/etc/catalog/mysql.properties <<EOF
connector.name=mysql
connection-url=$MYSQL_JDBC_URL
connection-user=$MYSQL_USERNAME
connection-password=$MYSQL_PASSWORD
EOF
fi

# PostreSQL 
if [ -n "$POSTGRESQL_JDBC_URL" ]; then
cat > $PRESTO_DIR/etc/catalog/postgresql.properties <<EOF
connector.name=postgresql
connection-url=$POSTGRESQL_JDBC_URL
connection-user=$POSTGRESQL_USERNAME
connection-password=$POSTGRESQL_PASSWORD
EOF
fi

# Start Presto
/opt/presto/bin/launcher run

# Spin wait
while true; do sleep 1000; done