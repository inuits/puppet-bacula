class bacula::common (
  $director_server   = $::bacula::params::director_server,
  $director_port     = $::bacula::params::director_port,
  $director_password = $::bacula::params::director_password,
) inherits ::bacula::params {

  include ::concat::setup
  class{'::bacula::bconsole':
    director_server   => $director_server,
    director_port     => $director_port,
    director_password => $director_password,
  }

  File{
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  file{$config_root:
    recurse => true,
    purge   => true,
  }
  file{"${config_root}/messages.d":}
  file{$working_dir:}
  file{$pid_dir:}
  file{$log_dir:
    mode => '0644',
  }

  file{'/etc/logrotate.d/bacula':
    ensure  => 'file',
    mode    => '0644',
    content => template('bacula/logrotate.erb'),
  }

  file{'/var/log/bacula.log':
    ensure => 'absent',
  }

}
