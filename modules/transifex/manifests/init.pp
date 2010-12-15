class transifex {
  package { ['transifex','python-psycopg2']:
    ensure => installed
  }
 
  $password = extlookup("transifex_password",'x')
  file { "20-engines.conf":
    path => "/etc/transifex/20-engines.conf",
    ensure => present,
    owner => root,
    group => apache,
    mode => 640,
    content => template("transifex/20-engines.conf"),
    require => Package['transifex']
  }

  file { "30-site.conf":
    path => "/etc/transifex/30-site.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/30-site.conf"),
    require => Package['transifex']
  }

#  apache::vhost_django_app { "transifex.$domain":
#    module => "transifex" 
#  }  
}
