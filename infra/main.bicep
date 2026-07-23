param location string = resourceGroup().location
param env string

resource logs 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'shipit-logs-${env}'
  location: location
  properties: {
    retentionInDays: 30
    sku: { name: 'PerGB2018' }
  }
}

resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: 'shipit-appi-${env}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logs.id      // workspace-based App Insights
  }
}

output connectionString string = appi.properties.ConnectionString
