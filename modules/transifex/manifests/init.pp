class transifex {
  package { 'transifex':
    ensure => installed
  }
 
  $password = extlookup("transifex_password") 
  file { "20-engines.conf":
    path => "/etc/transifex/20-engines.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 755,
    content => template("transifex/20-engines.conf")
  }

#  apache::vhost_django_app { "transifex.$domain":
#    module => "transifex" 
#  }  
}
