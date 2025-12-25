targetScope = 'subscription'

@allowed([
  'dev'
  'prod'
])
param env string

param location string = 'southeastasia'

var rgName = 'rg-portfolio-shared-${env}'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: {
    environment: env
    purpose: 'portfolio-shared'
  }
}
