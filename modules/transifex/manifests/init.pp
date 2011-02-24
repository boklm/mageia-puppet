class transifex {
  include django_application 
  package { 'transifex':
    ensure => installed
  }
 
  $pgsql_password = extlookup("transifex_pgsql",'x')
  $ldap_password = extlookup("transifex_ldap",'x')

  $templates_dir = "/var/lib/transifex/templates"

  @@postgresql::user { 'transifex':
        password => $pgsql_password,
  }

  @@postgresql::database { 'transifex':
        description => "Transifex database",
        user => "transifex",
        require => Postgresql::User['transifex']
  }

  file { "20-engines.conf":
    path => "/etc/transifex/20-engines.conf",
    ensure => present,
    owner => root,
    group => apache,
    mode => 640,
    content => template("transifex/20-engines.conf"),
    require => Package['transifex'],
    notify => Service['apache']
  }

  file { "30-site.conf":
    path => "/etc/transifex/30-site.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/30-site.conf"),
    require => Package['transifex'],
    notify => Service['apache']
  }

  file { "40-apps.conf":
    path => "/etc/transifex/40-apps.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/40-apps.conf"),
    require => Package['transifex'],
    notify => Service['apache']
  }

  file { "45-ldap.conf":
    path => "/etc/transifex/45-ldap.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/45-ldap.conf"),
    require => Package['transifex'],
    notify => Service['apache']
  }

  file { "50-project.conf":
    path => "/etc/transifex/50-project.conf",
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => template("transifex/50-project.conf"),
    require => Package['transifex'],
    notify => Service['apache']
  }

  subversion::snapshot { $templates_dir:
    source => "svn://svn.mageia.org/svn/web/templates/transifex/trunk"
  }

  apache::vhost_django_app { "transifex.$domain":
    module => "transifex",
    use_ssl => true,
    module_path => ["/usr/share/transifex","/usr/share","/usr/local/lib/"],
    aliases => { "/site_media/static/admin/" => "/usr/lib/python2.6/site-packages/django/contrib/admin/media/", },
  }

  apache::vhost_redirect_ssl { "transifex.$domain": }

  django_application::create_group { ["mga-i18n","mga-i18n-committers"]:
    module => "transifex",
    path => "/usr/share/transifex:/usr/share",
  }  

  django_application::add_permission_to_group { ['add_project','change_project','delete_project']:
    group => 'mga-i18n-committers',
    module => "transifex",
    path => "/usr/share/transifex:/usr/share",
    require => Django_application::Create_group['mga-i18n-committers'],
  }
}
