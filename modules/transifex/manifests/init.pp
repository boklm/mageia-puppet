class transifex {
  package { 'transifex':
    ensure => installed
  }
 
  $password = extlookup("transifex_password") 
  file { "20-engines.conf":
    path => "/etc/transifex/20-engines.conf",
    ensure => present,
    owner => root,
    group => apache,
    mode => 640,
    content => template("transifex/20-engines.conf")
  }

  file { "30-site.conf":
    path => "/etc/transifex/30-site.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/30-site.conf")
  }

#  apache::vhost_django_app { "transifex.$domain":
#    module => "transifex" 
#  }  
}
