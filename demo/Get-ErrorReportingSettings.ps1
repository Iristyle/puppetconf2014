$key = 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting'
Get-Item $key
Get-ChildItem $key | % { Get-Item $_.PSPath }
