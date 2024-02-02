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
  content => template('/home/baydev/puppet/lightdm.conf'),
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
  content => template('/home/baydev/puppet/config.txt'),
}

cron { 'checkGit':
  special => 'reboot',
  user    => 'baydev',
  command => '/usr/bin/sleep 30; /home/baydev/checkGit.sh reboot'
}

# * * * * * cd /home/baydev && /home/baydev/autostart.sh
cron {'autostart':
user => 'baydev',
  command => 'cd /home/baydev && /home/baydev/autostart.sh >/dev/null 2>&1'
}

# * * * * * sleep 15 && cd /home/baydev && /home/baydev/autostart.sh
cron {'autostart 15':
  user => 'baydev',
  command => 'sleep 15 && cd /home/baydev && /home/baydev/autostart.sh >/dev/null 2>&1'
}


# * * * * * sleep 30 && cd /home/baydev && /home/baydev/autostart.sh
cron {'autostart 30':
  user => 'baydev',
  command => 'sleep 30 && cd /home/baydev && /home/baydev/autostart.sh >/dev/null 2>&1'
}
# * * * * * sleep 45 && cd /home/baydev && /home/baydev/autostart.sh
cron {'autostart 45':
  user => 'baydev',
  command => 'sleep 45 && cd /home/baydev && /home/baydev/autostart.sh >/dev/null 2>&1'
}


# 11 */3 * * * /home/baydev/refreshBrowser.sh
cron {'refreshBrowser':
  user => 'baydev',
  minute => '11',
  hour => '*/3',
  command => '/home/baydev/refreshBrowser.sh'
}

# */5 * * * * cd /home/baydev && /home/baydev/screenshot.sh
cron {'screenshot':
  user => 'baydev',
  minute => '*/5',
  command => 'cd /home/baydev && /home/baydev/screenshot.sh >/dev/null 2>&1'
}



# @reboot sleep 30 && /usr/sbin/service lightdm start;
cron {'lightdm start':
  user => 'root',
  special => 'reboot',
  command => 'sleep 30 && /usr/sbin/service lightdm start'
}

# * * * * * sleep 5 && cd /home/baydev && /home/baydev/checkUpdates.sh;
cron {'checkUpdates 5':
  user => 'root',
  command => 'sleep 5 && cd /home/baydev && /home/baydev/checkUpdates.sh >/dev/null 2>&1'
}

# * * * * * sleep 20 && cd /home/baydev && /home/baydev/checkUpdates.sh;
cron {'checkUpdates 20':
  user => 'root',
  command => 'sleep 20 && cd /home/baydev && /home/baydev/checkUpdates.sh >/dev/null 2>&1'
}

# * * * * * sleep 35 && cd /home/baydev && /home/baydev/checkUpdates.sh;
cron {'checkUpdates 35':
  user => 'root',
  command => 'sleep 35 && cd /home/baydev && /home/baydev/checkUpdates.sh >/dev/null 2>&1'
}

# * * * * * sleep 5 && cd /home/baydev && /home/baydev/checkUpdates.sh;
cron {'checkUpdates 50':
  user => 'root',
  command => 'sleep 50 && cd /home/baydev && /home/baydev/checkUpdates.sh >/dev/null 2>&1'
}

# check alive
cron {'check alive':
  user => 'baydev',
  minute => '*',
  command => '/bin/bash /home/baydev/checkAlive.sh' # 2>&1'
}



#################

package { 'mariadb-server': ensure => 'present' }


mysql::db { 'log':
  user     => 'raspi',
  password => 'raspi',
  host     => 'localhost',
  require => [Package['mariadb-server']],
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
  command => 'mysql log < log.sql',
  require => [Package['mariadb-server'], File['/home/baydev/.my.cnf'],  Mysql::Db['log']],
  cwd => '/home/baydev'
}

