puppet apply -e "file { 'c:/windows/temp/foo.txt': content => 'bar', ensure => present }"
