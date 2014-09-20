#
define iis::manage_binding($site_name, $protocol, $port, $host_header = '', $ip_address = '*', $certificate_thumbprint = '', $ensure = 'present') {
  include 'iis::param::powershell'

  if ! ($protocol in [ 'http', 'https', 'net.tcp', 'net.pipe', 'netmsmq', 'msmq.formatname' ]) {
    fail('valid protocols \'http\', \'https\', \'net.tcp\', \'net.pipe\', \'netmsmq\', \'msmq.formatname\'')
  }

  validate_string($site_name)
  validate_re($site_name,['^(.)+$'], 'site_name must not be empty')
  validate_re($ensure, '^(present|installed|absent|purged)$', 'ensure must be one of \'present\', \'installed\', \'absent\', \'purged\'')

  if ! ($ip_address == '*') {
    validate_re($ip_address, ['^([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}\.([0-9]){1,3}$'], "\"${ip_address}\" is not a valid ip address")
  }

  if ($ensure in ['present','installed']) {
    exec { "CreateBinding-${title}":
      path      => "${iis::param::powershell::path};${::path}",
      command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; New-WebBinding -Name \\\"${site_name}\\\" -Port ${port} -Protocol \\\"${protocol}\\\" -HostHeader \\\"${host_header}\\\" -IPAddress \\\"${ip_address}\\\"\"",
      onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if (Get-WebBinding -Name \\\"${site_name}\\\" -Port ${port} -Protocol \\\"${protocol}\\\" -HostHeader \\\"${host_header}\\\" -IPAddress \\\"${ip_address}\\\" | Where-Object {\$_.bindingInformation -eq \\\"${ip_address}:${port}:${host_header}\\\"}) { exit 1 } else { exit 0 }\"",
      logoutput => true,
      require   => Iis::Manage_site[$site_name],
    }

    if ($protocol == 'https') {
      validate_re($certificate_thumbprint, ['^(.)+$'], 'certificate_thumbprint required for https bindings')
      if ($ip_address == '0.0.0.0') {
        fail('https bindings require a valid ip_address')
      }

      file { "inspect-${title}-certificate.ps1":
        ensure  => present,
        path    => "C:\\temp\\inspect-${name}.ps1",
        content => template('iis/inspect-certificate-binding.ps1.erb'),
      }

      file { "create-${title}-certificate.ps1":
        ensure  => present,
        path    => "C:\\temp\\create-${name}.ps1",
        content => template('iis/create-certificate-binding.ps1.erb'),
      }

      exec { "Attach-Certificate-${title}":
        command   => "C:\\temp\\create-${name}.ps1",
        onlyif    => "C:\\temp\\inspect-${name}.ps1",
        require   => [File["inspect-${title}-certificate.ps1"], File["create-${title}-certificate.ps1"]],
        provider  => powershell,
        logoutput => true,
      }
    }
  } else {
    exec { "DeleteBinding-${title}":
    path      => "${iis::param::powershell::path};${::path}",
    command   => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; Remove-WebBinding -Name \\\"${site_name}\\\" -Port ${port} -Protocol \\\"${protocol}\\\" -HostHeader \\\"${host_header}\\\" -IPAddress \\\"${ip_address}\\\"\"",
    onlyif    => "${iis::param::powershell::command} -Command \"Import-Module WebAdministration; if (!(Get-WebBinding -Name \\\"${site_name}\\\" -Port ${port} -Protocol \\\"${protocol}\\\" -HostHeader \\\"${host_header}\\\" -IPAddress \\\"${ip_address}\\\" | Where-Object {\$_.bindingInformation -eq \\\"${ip_address}:${port}:${host_header}\\\"})) { exit 1 } else { exit 0 }\"",
    logoutput => true,
    }
  }
}

