#!/bin/bash

# Start Hadoop
/etc/bootstrap.sh -d &

# Start the metastore
hive --service metastore --hiveconf hive.root.logger=DEBUG,console --hiveconf fs.azure.account.key.${AZURE_STORAGE_ACCOUNT_NAME}.blob.core.windows.net=${AZURE_STORAGE_ACCOUNT_KEY} --hiveconf fs.adl.impl=org.apache.hadoop.fs.adl.AdlFileSystem --hiveconf fs.AbstractFileSystem.adl.impl=org.apache.hadoop.fs.adl.Adl --hiveconf dfs.adls.oauth2.access.token.provider.type=ClientCredential --hiveconf dfs.adls.oauth2.client.id=${ADLS_CLIENT_ID} --hiveconf dfs.adls.oauth2.credential=${ADLS_CLIENT_SECRET} --hiveconf dfs.adls.oauth2.refresh.url=https://login.microsoftonline.com/${ADLS_TENANT_ID}/oauth2/token

# Spin wait
# while true; do sleep 1000; done