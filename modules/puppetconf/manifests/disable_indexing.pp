# == Class: disable_indexing
#
# Disable the drive indexing feature on root drive for perf reasons
#
class puppetconf::disable_indexing {
  $drive = 'C:'

  exec { 'disable-c-indexing':
    command   => template('puppetconf/Disable-Indexing.ps1.erb'),
    provider  => powershell,

    # DON'T FORGET IDEMPOTENCY YO!
    # unless    => "if (!(Get-WmiObject -Class Win32_Volume -Filter 'DriveLetter=\"${drive}\"').IndexingEnabled) { exit 1}",
  }
}
