param env string
param location string
param appName string
param appServicePlanName string
param dotnetVersion string = '9.0' // default .NET 9

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${appName}-${env}'
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    httpsOnly: true
    siteConfig: {
      windowsFxVersion: 'DOTNET|${dotnetVersion}' // use param
      alwaysOn: true
      http20Enabled: true
    }
  }
  tags: {
    Environment: env
    Project: appName
  }
}

output webAppName string = webApp.name
output webAppDefaultHostName string = webApp.properties.defaultHostName
