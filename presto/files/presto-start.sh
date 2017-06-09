#!/bin/bash

# Update config file with credentials for WASB and ADLS
config=/opt/presto/etc/catalog/adls-wasb-site.xml

sed -i -e "s/ADLS_TENANT_ID/${ADLS_TENANT_ID}/g" $config
sed -i -e "s/ADLS_CLIENT_ID/${ADLS_CLIENT_ID}/g" $config
sed -i -e "s#ADLS_CLIENT_SECRET#${ADLS_CLIENT_SECRET}#g" $config

sed -i -e "s/AZURE_STORAGE_ACCOUNT_NAME/${AZURE_STORAGE_ACCOUNT_NAME}/g" $config
sed -i -e "s#AZURE_STORAGE_ACCOUNT_KEY#${AZURE_STORAGE_ACCOUNT_KEY}#g" $config

# Start Presto
/opt/presto/bin/launcher run

# Spin wait
while true; do sleep 1000; done