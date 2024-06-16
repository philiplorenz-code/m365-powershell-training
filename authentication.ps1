# Guide
https://pnp.github.io/powershell/articles/authentication.html

# Create env
New-Item -Type Directory -Path ./app-auth -Force

# Create a new Azure AD Application for authorization
New-Item -Type Directory -Path ./app-auth -Force
$params = @{
  ApplicationName = "PnPAutomation"
  Tenant          = "philiplorenz.onmicrosoft.com"
  OutPath         = "./app-auth"
  DeviceLogin     = $true
}
$result = Register-PnPAzureADApp @params
$result.'AzureAppId/ClientId' | Out-File ./app-auth/clientid.txt
$result.Base64Encoded | Out-File ./app-auth/PnPPowerShellAutomation.pfx


# Connect to a SharePoint Online tenant with the new Azure AD Application
$clientid = Get-Content ./app-auth/clientid.txt
$certbase64 = Get-Content ./app-auth/PnPPowerShellAutomation.pfx

$params = @{
  Url                      = "https://philiplorenz.sharepoint.com"
  ClientId                 = $clientid
  Tenant                   = "philiplorenz.onmicrosoft.com"
  CertificateBase64Encoded = $certbase64
  ReturnConnection         = $true
}
$con = Connect-PnPOnline @params

# Check if the connection was successful
Get-PnPTenant -Connection $con

### Manual steps: Windows Only
$conMan = Connect-PnPOnline -UseWebLogin -Url "https://philiplorenz.sharepoint.com"