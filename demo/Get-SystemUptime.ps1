$wmi = Get-WmiObject -Class Win32_OperatingSystem
$wmi.ConvertToDateTime($wmi.LocalDateTime) - $wmi.ConvertToDateTime($wmi.LastBootUpTime)
