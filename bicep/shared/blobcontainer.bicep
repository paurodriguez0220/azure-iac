// modules/games/blobcontainer.bicep
param storageAccountName string
param containerName string = 'gameassets'  // default container

// Blob container resource
resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: 'None' // private container
  }
}

// Outputs
output containerName string = blobContainer.name
