#!/bin/bash


# Variables
RESOURCE_GROUP="Monocle_Tech"
SQL_SERVER_NAME="ba-sql01"
KEYVAULT_NAME="bakv01"

# Check if the SQL server exists
EXISTING_SERVER=$(az sql server show --name $SQL_SERVER_NAME --resource-group $RESOURCE_GROUP --query id --output tsv)

# If the server exists, delete it
if [ -n "$EXISTING_SERVER" ]; then
  echo "Deleting existing SQL server: $SQL_SERVER_NAME"
  az sql server delete --name $SQL_SERVER_NAME --resource-group $RESOURCE_GROUP --yes
else
  echo "No existing SQL server found with name: $SQL_SERVER_NAME"
fi

# Check if the Key Vault exists
EXISTING_KEYVAULT=$(az keyvault show --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP --query id --output tsv)

# If the Key Vault exists, delete it
if [ -n "$EXISTING_KEYVAULT" ]; then
  echo "Deleting existing Key Vault: $KEYVAULT_NAME"
  az keyvault delete --name $KEYVAULT_NAME --resource-group $RESOURCE_GROUP
  # Purge the Key Vault to allow recreation with the same name
  az keyvault purge --name $KEYVAULT_NAME
else
  echo "No existing Key Vault found with name: $KEYVAULT_NAME"
fi
