param env string
param location string
param appName string
param skuName string = 'Standard_LRS' // default storage SKU
param kind string = 'StorageV2'       // default kind for general-purpose v2


var safeAppName = toLower(replace(appName, '[^a-z0-9]', ''))
var safeEnv = toLower(replace(env, '[^a-z0-9]', ''))

// Storage Account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'st${safeAppName}${safeEnv}'  // guaranteed valid
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  tags: {
    Environment: env
    Project: appName
  }
}

// Output the storage account name and primary blob endpoint
output storageAccountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
