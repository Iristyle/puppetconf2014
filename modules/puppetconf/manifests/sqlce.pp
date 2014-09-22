class puppetconf::sqlce {

  $installer = 'SSCERuntime_x64-ENU.exe'

  package { 'Microsoft SQL Server Compact 4.0 SP1 x64 ENU':
    ensure => '4.0.8876.1',
    provider => 'windows',
    # NOTE: would like to use this Puppet style, but must have file staged
    # source => "puppet:///modules/puppetconf/${installer}",
    source => "C:/vagrant/modules/puppetconf/files/${installer}",
    install_options => [ '/i', '/passive'] # [ '/qn' ] #/l*v install.txt
  }
}
