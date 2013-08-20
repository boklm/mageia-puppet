class mgagit(
  $git_dir = '/git',
  $ldap_server = 'ldap.mageia.org',
  $binddn = 'uid=mgagit,ou=People,dc=mageia,dc=org',
  $vhost = 'projects.mageia.org',
  $bindpw
){
  $git_login = 'git'
  $git_homedir = "/var/lib/${git_login}"
  $gitolite_dir = "${git_homedir}/.gitolite"
  $gitolite_keydir = "${gitolite_dir}/keydir"
  $gitolite_tmpldir = "/etc/mgagit/tmpl"
  $gitolite_confdir = "${gitolite_dir}/conf"
  $gitolite_conf = "${gitolite_confdir}/gitolite.conf"
  $gitoliterc = "$git_homedir/.gitolite.rc"
  $bindpwfile = '/etc/mgagit.secret'
  $reposconf_dir = "${git_homedir}/repos-config"
  $vhostdir = "$git_homedir/www"

  package { ['mgagit', 'gitolite']:
    ensure => installed,
  }

  group { $git_login:
    ensure => present,
  }
  user { $git_login:
    ensure      => present,
    comment     => 'Git user',
    home        => $git_homedir,
    managehome  => true,
    gid         => $git_login,
  }

  file { '/etc/mgagit.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mgagit/mgagit.conf'),
    require => Package['mgagit'],
  }

  file { $gitolite_tmpldir:
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  file { "$gitolite_tmpldir/group.gl":
    ensure => 'link',
    target => '/usr/share/mgagit/tmpl/group.gl',
  }

  file { "$gitolite_tmpldir/repodef_repo.gl":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('mgagit/repodef_repo.gl'),
  }

  mgagit::tmpl { 'soft':
    tmpdir => $gitolite_tmpldir,
    group => 'packages',
  }

  mgagit::tmpl { 'web':
    tmpdir => $gitolite_tmpldir,
    ml => 'atelier',
  }

  file { [$gitolite_dir, $gitolite_keydir, $gitolite_confdir,
          $reposconf_dir, $vhostdir]:
    ensure => directory,
    owner  => $git_login,
    group  => $git_login,
    mode   => '0755',
  }

  file { $gitoliterc:
    ensure  => present,
    owner   => $git_login,
    group   => $git_login,
    mode    => '0644',
    content => template('mgagit/gitolite.rc'),
  }

  file { $bindpwfile:
    ensure  => present,
    owner   => $git_login,
    group   => $git_login,
    mode    => '0600',
    content => inline_template('<%= @bindpw %>'),
  }

  file { $git_dir:
    ensure => directory,
    owner  => $git_login,
    group  => $git_login,
    mode   => '0755',
  }

  file { "$git_homedir/repositories":
    ensure => 'link',
    target => $git_dir,
  }

  apache::vhost::base { $vhost:
    location => $vhostdir,
  }
}
# vim: sw=2
