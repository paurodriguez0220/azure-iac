param env string
param location string
param appName string

/* -----------------------------
   Key Vault
--------------------------------*/
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-${appName}-${env}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [] // access policies can be added later
    enableSoftDelete: true
    enablePurgeProtection: true
  }
  tags: {
    Environment: env
    Project: appName
  }
}

output keyVaultName string = kv.name
output keyVaultId string = kv.id
