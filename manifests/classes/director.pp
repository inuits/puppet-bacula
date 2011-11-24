# /etc/puppet/modules/bacula/manifests/director.pp

class bacula::director {
  include concat::setup

  package { bacula-director-mysql:
    ensure   => latest,
    require  => Package["mysql-server"];
  }

  file {
    "/usr/sbin/bacula-dir.mysql":
      owner => "root",
      group => "root",
      mode  => 755;

    "/root/bin":
      ensure  => directory,
      owner   => "root",
      group   => "root",
      mode    => 700;

    "/root/bin/label_storage.sh":
      owner   => "root",
      group   => "root",
      mode    => 755,
      source  => 'puppet:///modules/bacula/label_storage.sh',
      require => File["/root/bin"];

    "/etc/bacula/bacula-dir.conf":
      owner   => root,
      group   => root,
      mode    => 640,
      require => Package["bacula-director-mysql"],
      notify  => Service["bacula-dir"],
      content => template('bacula/bacula-dir.conf.erb');
  }

  iptables::rule {
    'bacula-dir':
      dport => '9101';
  }

  mysql_db {
	"$bacula::dbname":
		user => "$bacula::dbuser",
		pass => "$bacula::dbpassword",
		host => "$bacula::dbhost";
  }

  exec {
    "bacula-db-tables":
      command     => "/usr/libexec/bacula/make_bacula_tables -u$bacula::dbuser -p$bacula::dbpassword",
      environment => "db_name=$bacula::dbname",
      subscribe   => Package["bacula-director-mysql"],
      require     => Mysql_db["${bacula::dbname}"],
      unless      => "/usr/bin/mysqlshow -uroot -p$bacula::dbpassword $bacula::dbname | grep Version",
      before      => Service["bacula-dir"];
  }

  service { "bacula-dir":
    ensure  => running,
    enable  => true,
    require => [ Package[bacula-director-mysql], Service['mysqld'] ];
  }

  Bacula::Client <<| |>>
}
