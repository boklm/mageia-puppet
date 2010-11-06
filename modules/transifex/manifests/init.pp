class transifex {
  package { 'transifex':
    ensure => installed
  }
  package { 'postfix':
    ensure => installed
  }

  file { "check_new-blog-post":
    path => "/etc/transifex/20-engines.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    content => template("transifex/20-engines.conf")
  }
}
