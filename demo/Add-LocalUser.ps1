[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]
  [ValidateLength(1, 20)]
  $UserName,

  [Parameter(Mandatory = $true)]
  [String]
  [ValidateLength(1, 20)]
  $Password
)

$computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

$users = $computer.Children |
  ? {$_.SchemaClassName -eq 'user'} |
  % {$_.name[0]}

if ($users -contains $UserName)
{
  Write-Warning "User $UserName already exists!"
}
else
{
  $user = $computer.Create('User', $UserName)
  $user.SetPassword($Password)
  $user.SetInfo()
}


## but wait, what about the home directory?
## what if we want to remove a user?
