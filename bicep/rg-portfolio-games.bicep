targetScope = 'subscription'
param location string = 'southeastasia'
param swaLocation string = 'eastasia'
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
module appServicePlan 'shared/appserviceplan.bicep' = {
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
   5️⃣ Blob Storage Module
--------------------------------*/
module blobStorage 'shared/blobstorage.bicep' = {
  name: 'blobStorageModule'
  params: {
    location: location
    env: env
    appName: 'portfolio-games'
  }
  scope: resourceGroup(rgName) // use your known resource group
  dependsOn: [
    resGroup  // assuming resGroup is the resource group creation step
  ]
}

/* -----------------------------
   6️⃣ Static Web App (React)
--------------------------------*/
module staticMiniSteamUI 'shared/staticwebapp.bicep' = {
  name: 'staticMiniSteamUIModule'
  params: {
    location: swaLocation
    env: env
    appName: 'swa-portfolio-games-ministeam'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

module staticMinesweeper 'shared/staticwebapp.bicep' = {
  name: 'staticMinesweeperModule'
  params: {
    location: swaLocation
    env: env
    appName: 'swa-portfolio-games-minesweeper'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

module static2048 'shared/staticwebapp.bicep' = {
  name: 'static2048Module'
  params: {
    location: swaLocation
    env: env
    appName: 'swa-portfolio-games-2048'
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

module staticSnake 'shared/staticwebapp.bicep' = {
  name: 'staticSnakeModule'
  params: {
    location: swaLocation
    env: env
    appName: 'swa-portfolio-games-snake'
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
    appName: 'portfolio-game'
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

module appService_MiniSteam 'shared/appservice.bicep' = {
  name: 'appServiceModule'
  params: {
    env: env
    location: location
    appName: 'portfolio-games-ministeam-api'
    appServicePlanName: appServicePlan.outputs.appServicePlanName
    dotnetVersion: '9.0' // can override if needed
  }
  scope: resourceGroup(rgName)
  dependsOn: [
    resGroup
  ]
}

