## Boot to Console
file { '/etc/systemd/system/default.target':
  ensure => 'link',
  mode   => '0777',
  owner  => 'root',
  target => '/lib/systemd/system/multi-user.target',
}

## No Autologin on Console
file { '/etc/systemd/system/getty@tty1.service.d/autologin.conf':
  ensure => "absent",
}

# Autologin on Desktop
file { '/etc/lightdm/lightdm.conf':
  ensure  => 'file',
  content => template('/home/baydev/puppet/lightdm.conf')
}

# Ensure git is present
package { 'git':
  ensure => 'present',
}

# Boot Settings (This file is linked to /boot/config.txt)
file { '/boot/firmware/config.txt':
  ensure  => 'file',
  owner   => 'root',
  mode    => '0755',
  content => template('/home/baydev/puppet/config.txt')
}

# mutt
package { 'mutt': ensure => 'installed' }


# puppet module 'reboot'
exec { 'install-reboot-module':
  command => '/usr/bin/puppet module install puppetlabs/reboot',
  unless  => '/usr/bin/puppet module list | grep reboot',
  path    => ['/bin', '/usr/sbin', '/usr/bin'],
}


