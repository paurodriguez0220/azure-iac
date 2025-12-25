param env string
param location string
param appName string

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${appName}-${env}'
  location: location
  sku: {
    name: 'B1'   // Basic tier to save cost
    tier: 'Basic'
    capacity: 1
  }
  kind: 'app'
  properties: {}
}

output appServicePlanName string = asp.name
