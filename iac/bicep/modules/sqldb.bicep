// Parameters
@description('The name of the SQL server.')
param sqlserver_name string

@description('The name of the database.')
param database_name string

@description('The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Cost Centre tag that will be applied to all resources in this deployment')
param cost_centre_tag string

@description('System Owner tag that will be applied to all resources in this deployment')
param owner_tag string

@description('Subject Matter Expert (SME) tag that will be applied to all resources in this deployment')
param sme_tag string

@description('The Active Directory admin username for the SQL server.')
@secure()
param ad_admin_username string

@description('The Active Directory admin SID for the SQL server.')
@secure()
param ad_admin_sid string

@description('The password for the SQL server administrator.')
@secure()
param admin_password string

@description('The auto-pause duration for the database.')
param auto_pause_duration int = 60

@description('The SKU name for the database.')
param database_sku_name string = 'GP_S_Gen5_1'

// Variables
var suffix = uniqueString(resourceGroup().id)
var sqlserver_uniquename = '${sqlserver_name}${suffix}'
var database_uniquename = '${database_name}${suffix}'

// Resource: SQL Server
resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlserver_uniquename
  location: location
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
  properties: {
    administratorLogin: ad_admin_username
    administratorLoginPassword: admin_password
  }
}

// Resource: SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${sqlserver_uniquename}/${database_uniquename}'
  location: location
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
  sku: {
    name: database_sku_name
  }
  properties: {
    autoPauseDelay: auto_pause_duration
  }
  dependsOn: [
    sqlServer
  ]
}

// Outputs
@description('The ID of the SQL server.')
output sqlServerId string = sqlServer.id

@description('The name of the SQL server.')
output sqlServerName string = sqlServer.name

@description('The ID of the SQL database.')
output sqlDatabaseId string = sqlDatabase.id

@description('The name of the SQL database.')
output sqlDatabaseName string = sqlDatabase.name
