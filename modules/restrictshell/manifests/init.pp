#TODO: add support for pkgsubmit
class restrictshell {
  $allow_svn = "0"
  $allow_git = "0"
  $allow_rsync = "0"
  $allow_pkgsubmit = "0"

  class allow_svn_git_pkgsubmit {
    $allow_svn = "1"
    $allow_git = "1"
    $allow_pkgsubmit = "1"
  }

  file { '/usr/local/bin/sv_membersh.pl':
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    content => template("restrictshell/sv_membersh.pl"),
  }

  file { '/etc/membersh-conf.pl':
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    content => template("restrictshell/membersh-conf.pl"),
  }
}
