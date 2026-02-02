param env string
param location string
param appName string
param skuName string = 'Standard_LRS' // default storage SKU
param kind string = 'StorageV2'       // default kind for general-purpose v2

// Storage Account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'st${appName}${env}' // storage account names must be globally unique, lowercase
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: 'Hot'          // default access tier
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
