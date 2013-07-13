class mgapeople(
  $site_name = 'people.mageia.org',
  $groupbase = 'ou=Group,dc=mageia,dc=org',
  $maintdburl = undef,
  $ldap_server,
  $binddn,
  $bindpw,
  $vhost,
  $vhostdir
){
  $mgapeople_login = 'mgapeople'
  $bindpw_file = '/etc/mgapeople.ldapsecret'

  group { $mgapeople_login:
    ensure => present,
  }

  user { $mgapeople_login:
    ensure     => present,
    comment    => 'mgapeople user',
    home       => "/var/lib/${mgapeople_login}",
    managehome => true,
    gid        => $mgapeople_login,
  }

  file { $bindpw_file:
    ensure  => present,
    owner   => $mgapeople_login,
    group   => $mgapeople_login,
    mode    => '0600',
    content => $bindpw,
  }

  package { 'mgapeople':
    ensure => installed,
  }

  file {'/etc/mgapeople.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mgapeople/mgapeople.conf'),
    require => Package['mgapeople'],
  }

  file { $vhostdir:
    ensure => directory,
    owner  => $mgapeople_login,
    group  => $mgapeople_login,
    mode   => '0755',
  }

  apache::vhost::base { $vhost:
    location => $vhostdir,
    require  => File[$vhostdir],
    aliases  => {
      '/static' => '/usr/share/mgapeople/static',
    },
  }

  cron { '/usr/bin/mkpeople':
    command => '/usr/bin/mkpeople',
    user    => $mgapeople_login,
    hour    => '*/2',
    minute  => '10',
  }
}
# vim: sw=2
