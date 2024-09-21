
package { 'mariadb-server': ensure => 'present' }

# apt update
exec { 'update_package_sources':
  command => '/usr/bin/apt-get update',
  path    => ['/usr/bin', '/usr/sbin'],
}

# Crons
exec { 'install-cron-module':
  path    => ['/opt/puppetlabs/bin', '/usr/bin', '/usr/sbin'],
  command => 'puppet module install puppetlabs-cron_core',
}

exec { 'install mysql module':
  path    => '/usr/bin',
  command => 'puppet module install puppetlabs-mysql',
}

exec {'clear crons baydev':
  user => 'baydev',
  command => 'crontab -r',
  path    => ['/usr/bin', '/usr/sbin']
}

exec {'clear crons root':
  user => 'root',
  command => 'crontab -r',
  path    => ['/usr/bin', '/usr/sbin']
}

