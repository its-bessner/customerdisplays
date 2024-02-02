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




