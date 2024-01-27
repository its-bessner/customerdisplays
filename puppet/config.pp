class mymodule::systemd {
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
}

class mymodule::lightdm {
  # Autologin on Desktop
  file { '/etc/lightdm/lightdm.conf':
    ensure  => 'file',
    content => template('mymodule/lightdm.conf.erb'),
  }
}

class mymodule::packages {
  # Ensure git is present
  package { 'git': ensure => 'present' }

  # mutt
  package { 'mutt': ensure => 'installed' }
}

class mymodule::boot_settings {
  # Boot Settings (This file is linked to /boot/config.txt)
  file { '/boot/firmware/config.txt':
    ensure  => 'file',
    owner   => 'root',
    mode    => '0755',
    content => template('config.txt'),
  }
}

class mymodule::puppet_reboot_module {
  # puppet module 'reboot'
  exec { 'install-reboot-module':
    command => '/opt/puppetlabs/bin/puppet module install puppetlabs/reboot',
    unless  => '/opt/puppetlabs/bin/puppet module list | grep reboot',
    path    => ['/usr/bin', '/usr/sbin', '/usr/bin'],
  }
}


class install_cron_module {
  exec { 'install-cron-module':
    path    => '/opt/puppetlabs/bin:/usr/bin:/usr/sbin',
    command => 'puppet module install puppetlabs-cron_core',
    unless  => 'puppet module list | grep cron_core',
  }
}



class mymodule::cron{
  cron {'checkGit':
    special =>  'reboot',
    user => 'baydev',
    command => '/home/baydev/checkGit.sh'
  }
}
