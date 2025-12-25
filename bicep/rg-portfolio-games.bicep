targetScope = 'subscription'
param location string = 'southeastasia'
param sqlAdmin string
@secure()
param sqlPassword string

@allowed([
  'dev'
  'prod'
])
param env string = 'dev'

// Fixed RG name variable
var rgName = 'rg-portfolio-games-${env}'

/* -----------------------------
   1️⃣ Create Resource Group
--------------------------------*/
resource resGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: {
    environment: env
    purpose: 'portfolio-games'
  }
}

/* -----------------------------
   2️⃣ App Service Plan
--------------------------------*/
module appService 'shared/appserviceplan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    location: location
    env: env
    appName: 'portfolio-games'
  }
  scope: resourceGroup(rgName)   // use known RG name
  dependsOn: [
    resGroup
  ]
}

/* -----------------------------
   3️⃣ Log Analytics
--------------------------------*/
module logAnalytics 'shared/loganalytics.bicep' = {
  name: 'logAnalyticsModule'
  params: {
    location: location
    env: env
    appName: 'portfolio-games'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

/* -----------------------------
   4️⃣ Azure SQL Server + Database
--------------------------------*/
module sql 'shared/sqlserver.bicep' = {
  name: 'sqlModule'
  params: {
    env: env
    location: location
    sqlAdmin: sqlAdmin
    sqlPassword: sqlPassword
    dbName: 'gamesappdb'
    appName: 'portfolio'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

/* -----------------------------
   5️⃣ Key Vault + SQL Secret
--------------------------------*/
module keyVault 'shared/keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    env: env
    location: location
    appName: 'portfolio-dev'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
    sql  // if you want to also create the secret here
  ]
}

module sqlSecret 'shared/keyvault-secret.bicep' = {
  name: 'sqlSecretModule'
  params: {
    keyVaultName: keyVault.outputs.keyVaultName
    secretName: 'SqlConnectionString'
    secretValue: 'Server=tcp:${sql.outputs.sqlServerName}.${environment().suffixes.sqlServerHostname},1433;Initial Catalog=gamesdb;Persist Security Info=False;User ID=${sqlAdmin};Password=${sqlPassword};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
  scope: resourceGroup(rgName)
}
