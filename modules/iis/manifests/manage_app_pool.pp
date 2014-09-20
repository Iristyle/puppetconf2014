#
define iis::manage_app_pool($app_pool_name = $title, $enable_32_bit = false, $managed_runtime_version = 'v4.0', $managed_pipeline_mode = 'Integrated', $ensure = 'present') {

  validate_bool($enable_32_bit)
  validate_re($managed_runtime_version, ['^(v2\.0|v4\.0)$'])
  validate_re($managed_pipeline_mode, ['^(Integrated|Classic)$'])
  validate_re($ensure, '^(present|installed|absent|purged)$', 'ensure must be one of \'present\', \'installed\', \'absent\', \'purged\'')

  include 'param::powershell'

  if ($ensure in ['present','installed']) {
    exec { "Create-${app_pool_name}" :
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; New-Item \\\"IIS:\\AppPools\\${app_pool_name}\\\"\"",
      path      => "${iis::param::powershell::path};${::path}",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if((Test-Path \\\"IIS:\\AppPools\\${app_pool_name}\\\")) { exit 1 } else {exit 0}\"",
      logoutput => true,
    }

    exec { "Framework-${app_pool_name}" :
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; Set-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" managedRuntimeVersion ${managed_runtime_version}\"",
      path      => "${iis::param::powershell::path};${::path}",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if((Get-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" managedRuntimeVersion).Value.CompareTo('${managed_runtime_version}') -eq 0) { exit 1 } else { exit 0 }\"",
      require   => Exec["Create-${app_pool_name}"],
      logoutput => true,
    }

    exec { "32bit-${app_pool_name}" :
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; Set-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" enable32BitAppOnWin64 ${enable_32_bit}\"",
      path      => "${iis::param::powershell::path};${::path}",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if((Get-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" enable32BitAppOnWin64).Value -eq [System.Convert]::ToBoolean('${enable_32_bit}')) { exit 1 } else { exit 0 }\"",
      require   => Exec["Create-${app_pool_name}"],
      logoutput => true,
    }

    exec { "ManagedPipelineMode-${app_pool_name}" :
      path      => "${iis::param::powershell::path};${::path}",
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; Set-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" managedPipelineMode ${managed_pipeline_mode}\"",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if((Get-ItemProperty \\\"IIS:\\AppPools\\${app_pool_name}\\\" managedPipelineMode).Value.CompareTo('${managed_pipeline_mode}') -eq 0) { exit 1 } else { exit 0 }\"",
      require   => Exec["Create-${app_pool_name}"],
      logoutput => true,
    }
  } else {
    exec { "Delete-${app_pool_name}" :
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; Remove-Item \\\"IIS:\\AppPools\\${app_pool_name}\\\" -Recurse\"",
      path      => "${iis::param::powershell::path};${::path}",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if(!(Test-Path \\\"IIS:\\AppPools\\${app_pool_name}\\\")) { exit 1 } else {exit 0}\"",
      logoutput => true,
    }
  }
}
