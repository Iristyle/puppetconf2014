# https://docs.puppetlabs.com/references/latest/type.html#user
user { 'jim':
  # on Windows can use use username, domain\user and SID
  name                 => 'jim',
  ensure               => present,
  managehome           => true,
  password             => 'bob'
  groups               => ['Administrators', 'Users']
}
