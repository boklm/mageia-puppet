class mga-advisories(
  $advisories_svn = 'svn://svn.mageia.org/svn/advisories',
  $vhost
){
  $mgaadv_login = 'mga-advisories'
  $mgaadv_homedir = "/var/lib/${mgaadv_login}"
  $vhostdir = "${mgaadv_homedir}/vhost"
  $advisories_dir = "${mgaadv_homedir}/advisories"
  $status_dir = "${mgaadv_homedir}/status"
  $update_script = '/usr/local/bin/update_mga-advisories'

  group { $mgaadv_login:
    ensure => present,
  }

  user { $mgaadv_login:
    ensure     => present,
    comment    => 'mga-advisories user',
    home       => $mgaadv_homedir,
    managehome => true,
    gid        => $mgaadv_login,
  }

  package { 'mga-advisories':
    ensure => installed,
  }

  file {'/etc/mga-advisories.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mga-advisories/mga-advisories.conf'),
    require => Package['mga-advisories'],
  }

  file { [ $vhostdir, $status_dir ]:
    ensure => directory,
    owner  => $mgaadv_login,
    group  => $mgaadv_login,
    mode   => '0755',
  }

  apache::vhost::base { $vhost:
    location => $vhostdir,
    aliases  => {
      "/static" => '/usr/share/mga-advisories/static',
    },
    require  => File[$vhostdir],
  }

  apache::vhost::base { "ssl_$vhost":
    use_ssl  => true,
    vhost    => $vhost,
    location => $vhostdir,
    require  => File[$vhostdir],
  }

  subversion::snapshot { $advisories_dir:
    source  => $advisories_svn,
    user    => $mgaadv_login,
    refresh => '0',
    require => User[$mgaadv_login],
  }

  file { $update_script:
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('mga-advisories/update_script'),
  }

  cron { $update_script:
    command => $update_script,
    user    => $mgaadv_login,
    hour    => '*',
    minute  => '10',
    require => Subversion::Snapshot[$advisories_dir],
  }
}
# vim: sw=2
