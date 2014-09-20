$command = {
  $features = @()

  try
  {
    $features = Get-WindowsFeature |
      ? { $_.Installed } |
      Select -ExpandProperty Name
  }
  catch {}

  "windows_features=$($features -join ',')"
}

if ([IntPtr]::Size -eq 8)
{
  &$command
  return
}

$ps = @(
    "${Env:SystemRoot}\sysnative\WindowsPowershell\v1.0\powershell.exe",
    'powershell.exe') |
  ? { (Test-Path $_) -or (Get-Command $_ -ErrorAction SilentlyContinue) } |
  Select -First 1

# ensure that this blocks
$output = &$ps -Command $command

$output
