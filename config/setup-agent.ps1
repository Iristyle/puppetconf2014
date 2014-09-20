$vagrantPath = "$Env:SystemDrive\vagrant"
$puppetConfigPath = "$Env:ALLUSERSPROFILE\PuppetLabs"

Copy-Item -Path "$vagrantPath\facts\windows_features.ps1" -Destination "$puppetConfigPath\facter\facts.d\windows_features.ps1" -Force

$demoPath = "${Env:SystemDrive}\demo"
Remove-Item -Path $demoPath -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$vagrantPath\demo" -Destination $demoPath -Recurse
