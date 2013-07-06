define mgagit::reposconfig {
  include mgagit
  $giturl = "/git/infrastructure/repositories/${name}.git"
  $confdir = "${mgagit::reposconf_dir}/${name}"

  git::snapshot{ $confdir:
    source  => $giturl,
    user    => $mgagit::git_login,
    refresh => '0',
    require => File[$mgagit::reposconf_dir],
  }
}
# vim: sw=2
