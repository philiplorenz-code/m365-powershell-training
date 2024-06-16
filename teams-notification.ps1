$m365GroupsWithOnlyOneOwner
[string]$MessageCardBody = ""
foreach ($one in $m365GroupsWithOnlyOneOwner) {
  $MessageCardBody += "Group: $($one."Group Name")"
  $MessageCardBody += "<br /> Owner: $($one.GroupOwners.UserPrincipalName)"
  $MessageCardBody += "<br /> "
}



$JSONBody = [PSCustomObject][Ordered]@{
  "@type"      = "MessageCard"
  "@context"   = "<http://schema.org/extensions>"
  "summary"    = "Teams with only one owner: $($m365GroupsWithOnlyOneOwner.Count)"
  "themeColor" = '0078D7'
  "title"      = "Teams Owner Report: $($m365GroupsWithOnlyOneOwner.Count) Teams with only one owner"
  "text"       = $MessageCardBody
}

$TeamMessageBody = ConvertTo-Json $JSONBody

$parameters = @{
  "URI"         = "https://philiplorenz.webhook.office.com/webhookb2/b39331d6-3c27-47d4-9737-7d8da8666821@6831fc74-692f-492d-8d82-65198bb23a32/IncomingWebhook/adbdc7bca112480580b2d21c813baa46/59714a70-5bfd-4416-bcf7-2adf9c6ae551"
  "Method"      = 'POST'
  "Body"        = $TeamMessageBody
  "ContentType" = 'application/json'
}

Invoke-RestMethod @parameters
