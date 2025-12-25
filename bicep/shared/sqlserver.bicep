param env string
param location string = 'southeastasia'
param sqlAdmin string
@secure()
param sqlPassword string
param dbName string = 'appdb'
param appName string

/* -----------------------------
   SQL Server
--------------------------------*/
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: 'sql-${appName}-server-${env}'
  location: location
  properties: {
    administratorLogin: sqlAdmin
    administratorLoginPassword: sqlPassword
    minimalTlsVersion: '1.2'
  }
  tags: {
    Environment: env
    Project: 'shared'
  }
}

/* -----------------------------
   SQL Database
--------------------------------*/
resource sqlDb 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: dbName
  properties: {
    readScale: 'Disabled'
    zoneRedundant: false
  }
  sku: {
    name: 'GP_S_Gen5_1'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  tags: {
    Environment: env
    Project: 'shared'
  }
  location: location
}

output sqlServerName string = sqlServer.name
output databaseName string = sqlDb.name
