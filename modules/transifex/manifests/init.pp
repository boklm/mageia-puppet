class transifex {
  include django_application 
  package { 'transifex':
    ensure => installed
  }
 
  $pgsql_password = extlookup("transifex_pgsql",'x')
  $ldap_password = extlookup("transifex_ldap",'x')

  $templates_dir = "/var/lib/transifex/templates"

  postgresql::remote_db_and_user { 'transifex':
        description => "Transifex database",
        password => $pgsql_password,
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

  # tx need write access there when running in apache
  file { "/var/lib/transifex/scratchdir/storage_files":
    ensure => directory,
    owner => apache,
    group => apache,
    require => Package['transifex'],
  }

  apache::vhost_redirect_ssl { "transifex.$domain": }

  # the group are mapped from ldap, since AUTH_LDAP_FIND_GROUP_PERMS is set to yes
  # but the group need to exist in django first 
  django_application::create_group { ["mga-i18n","mga-i18n-committers"]:
    module => "transifex",
    path => "/usr/share/transifex:/usr/share",
  }  

  define committers_permission($app='')
  {
    # using django_application::add_permission_to_group may cause problem
    # if we install a 2nd django application with the same permission name ( as it need
    # to be unique )
    django_application::add_permission_to_group { $name:   
       app => $app,    
       group => 'mga-i18n-committers',
       module => "transifex",
       path => "/usr/share/transifex:/usr/share",
       require => Django_application::Create_group['mga-i18n-committers'],
    }
  }
  
  committers_permission { ['add_project',
                           'change_project',
                           'delete_project']: }

  committers_permission { [ 'add_resource',
                            'change_resource', 
                            'delete_resource']:
    app => "resources",
  } 
}
