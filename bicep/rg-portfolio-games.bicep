targetScope = 'subscription'

@allowed([
  'dev'
  'prod'
])

param env string = 'dev'
param location string = 'southeastasia'

var rgName = 'rg-portfolio-games-${env}'

resource resGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
  tags: {
    environment: env
    purpose: 'portfolio-games'
  }
}

module appService 'shared/appserviceplan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    location: location
    env: env
    appName: 'portfolio-games'
  }
  scope: resourceGroup(resGroup.name)
}

module logAnalytics 'shared/loganalytics.bicep' = {
  name: 'logAnalyticsModule'
  params: {
    location: location
    env: env
    appName: 'portfolio-games'
  }
  scope: resourceGroup(resGroup.name)
}
