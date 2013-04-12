class bacula::fd::config inherits ::bacula::fd {

  File{
    ensure => 'file',
    owner  => $user,
    group  => $group,
  }

  file{"${config_root}/bacula-fd.conf":
    mode    => '0640',
    content => template('bacula/bacula-fd.conf.erb'),
    require => Package[$fd_pkgname],
    notify  => Service[$fd_service_name],
  }

  file{'/usr/sbin/bacula-fd':
    mode  => '0755',
  }

  ::bacula::messages{'bacula-fd':}

  # Export client resource for director
  @@bacula::client{$client:
    storage_server   => $storage_server,
    storage_dir      => $storage_dir,
    storage_port     => $storage_port,
    storage_password => $storage_password,
    device_owner     => $device_owner,
    device_group     => $device_group,
    fd_port          => $fd_port,
    fd_password      => $fd_password,
    config_root      => $config_root,
    catalog          => $catalog,
  }

  Bacula::Messages <<| |>> { notify => Service[$fd_service_name] }

}
