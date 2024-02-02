# cron {'checkGit':
#   special =>  'reboot',
#   user => 'baydev',
#   command => '/home/baydev/checkGit.sh'
# }


# exec { 'install-reboot-module-3':
#   command => 'puppet module install puppetlabs/reboot',
#   path    => '/usr/bin',
# }
#
# exec { 'something': command => 'touch /home/baydev/willi', path => '/usr/bin' }
# exec { 'something2': command => 'touch /home/baydev/willi2', path => '/usr/bin' }
#
#
# exec { 'install-cron-module':
#   path    => ['/opt/puppetlabs/bin', '/usr/bin', '/usr/sbin'],
#   command => 'puppet module install puppetlabs-cron_core',
#   unless  => 'puppet module list | grep cron_core',
# }


# -----------------------------------------


mysql::db { 'log':
  user     => 'raspi',
  password => 'raspi',
  host     => 'localhost',
  grant    => ['ALL']
}

file { '/home/baydev/.my.cnf':
  ensure  => 'file',
  owner   => 'baydev',
  mode    => '0600',
  content => template('/home/baydev/puppet/.my.cnf')
}



exec { 'create log table':
  path    => '/usr/bin',
  command => 'mysql log < /home/baydev/log.sql'
}

