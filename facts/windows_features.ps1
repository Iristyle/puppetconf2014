$features = @()

try
{
  $features = Get-WindowsFeature |
    ? { $_.Installed } |
    Select -ExpandProperty Name
}
catch {}

"windows_features=$($features -join ',')"
