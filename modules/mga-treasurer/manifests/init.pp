class mga-treasurer(
  $grisbi_svn = 'svn://svn.mageia.org/svn/treasurer/grisbi',
  $grisbi_filename = 'mageia-accounts.gsb',
  $vhost,
  $vhostdir
){
  $mgatres_login = 'mga-treasurer'
  $mgatres_homedir = "/var/lib/${mgatres_login}"
  $grisbi_dir = "${mgatres_homedir}/grisbi"
  $grisbi_path = "${grisbi_dir}/${grisbi_filename}"

  $update_script = '/usr/local/bin/update_mga-treasurer'

  group { $mgatres_login:
    ensure => present,
  }

  user { $mgatres_login:
    ensure     => present,
    comment    => 'mga-treasurer user',
    home       => $mgatres_homedir,
    managehome => true,
    gid        => $mgatres_login,
  }

  package { 'mga-treasurer':
    ensure => installed,
  }

  file {'/etc/mga-treasurer.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mga-treasurer/mga-treasurer.conf'),
    require => Package['mga-treasurer'],
  }

  file { $vhostdir:
    ensure => directory,
    owner  => $mgatres_login,
    group  => $mgatres_login,
    mode   => '0755',
  }

  apache::vhost::base { $vhost:
    location => $vhostdir,
    aliases  => {
      "/${grisbi_filename}" => $grisbi_path,
    },
    require  => File[$vhostdir],
  }

  file { $update_script:
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('mga-treasurer/update_script'),
  }

  subversion::snapshot { $grisbi_dir:
    source  => $grisbi_svn,
    user    => $mgatres_login,
    refresh => '0',
    require => User[$mgatres_login],
  }

  cron { '/usr/bin/mktreasurer':
    command => '/usr/bin/mktreasurer',
    user    => $mgatres_login,
    hour    => '*/2',
    minute  => '10',
    require => Subversion::Snapshot[$grisbi_dir],
  }
}
# vim: sw=2
