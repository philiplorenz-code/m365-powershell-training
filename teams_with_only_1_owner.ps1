# Array to Hold Result - PSObjects
$m365GroupCollection = @()

# Retrieve all M365 groups associated with Microsoft teams
$m365Groups = Get-PnPMicrosoft365Group -Connection $con | where-object { $_.HasTeam -eq $true }

$m365Groups | ForEach-Object {
  $ExportVw = New-Object PSObject
  $ExportVw | Add-Member -MemberType NoteProperty -name "Group Name" -value $_.DisplayName
  $m365GroupOwnersName = @();
  $m365GroupMembersName = @();
    
  $m365GroupOwnersName += (Get-PnPMicrosoft365GroupOwner -Connection $con -Identity $_.GroupId);
  $m365GroupMembersName += (Get-PnPMicrosoft365GroupMember -Connection $con -Identity $_.GroupId);

  $ExportVw | Add-Member -MemberType NoteProperty -name "GroupOwners" -value $m365GroupOwnersName
  $ExportVw | Add-Member -MemberType NoteProperty -name "GroupMembers" -value $m365GroupMembersName
  $m365GroupCollection += $ExportVw
}


$m365GroupsWithOnlyOneOwner = @()
$m365GroupsWithOnlyOneOwner = $m365GroupCollection | where-object { $_.GroupOwners.Count -eq 1 }

$m365GroupsWithOnlyOneOwner = @()
foreach ($group in $m365Groups ) {
  $groupOwners = (Get-PnPMicrosoft365GroupOwner -Connection $con -Identity $group.GroupId)
  if ($groupOwners.Count -eq 1) {
    $m365GroupsWithOnlyOneOwner += $group
    Write-Host "Group: " $group.DisplayName " has only one owner"
  }
}


