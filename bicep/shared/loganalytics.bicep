param env string
param location string
param appName string

resource la 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'la-${appName}-${env}'
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
  tags: {
    Environment: env
    Project: appName
  }
}

output logAnalyticsName string = la.name
