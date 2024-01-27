  # Boot to Console
  file { '/etc/systemd/system/default.target':
    ensure => 'link',
    mode   => '0777',
    owner  => 'root',
    target => '/lib/systemd/system/multi-user.target',
  }

  # No Autologin on Console
  file { '/etc/systemd/system/getty@tty1.service.d/autologin.conf':
    ensure => "absent",
  }

  # Autologin on Desktop
  file { '/etc/lightdm/lightdm.conf':
    ensure  => 'file',
    content => template('mymodule/lightdm.conf.erb'),
  }

  # Ensure git is present
  package { 'git': ensure => 'present' }

  # mutt
  package { 'mutt': ensure => 'installed' }

  # Boot Settings (This file is linked to /boot/config.txt)
  file { '/boot/firmware/config.txt':
    ensure  => 'file',
    owner   => 'root',
    mode    => '0755',
    content => template('config.txt'),
  }

  # puppet module 'reboot'
  exec { 'install-reboot-module':
    command => 'puppet module install puppetlabs/reboot',
    unless  => 'puppet module list | grep reboot',
    path    => ['/usr/bin', '/usr/sbin', '/usr/bin'],
  }


  exec { 'install-cron-module':
    path    => '/opt/puppetlabs/bin:/usr/bin:/usr/sbin',
    command => 'puppet module install puppetlabs-cron_core',
    unless  => 'puppet module list | grep cron_core',
  }



  cron {'checkGit':
    special =>  'reboot',
    user => 'baydev',
    command => '/home/baydev/checkGit.sh reload'
  }
