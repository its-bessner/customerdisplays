# Crons
exec { 'install-cron-module':
  path    => ['/opt/puppetlabs/bin', '/usr/bin', '/usr/sbin'],
  command => 'puppet module install puppetlabs-cron_core',
}