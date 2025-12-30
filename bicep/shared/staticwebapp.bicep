param location string
param env string
param appName string

resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: '${appName}-${env}'
  location: location
  sku: {
    name: 'Free'
  }
  properties: {
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

output staticWebAppName string = staticWebApp.name
output staticWebAppId string = staticWebApp.id
