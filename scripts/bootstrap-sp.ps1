$SubscriptionId = "4d6302be-05c4-4bb7-b94f-2805445f5d1c"
$SpName = "github-bicep-deployer"

az ad sp create-for-rbac `
  --name $SpName `
  --role Contributor `
  --scopes "/subscriptions/$SubscriptionId" `
  --sdk-auth