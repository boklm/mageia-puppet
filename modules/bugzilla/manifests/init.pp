class bugzilla {

   $bugzilla_location = "/usr/share/bugzilla/template/en/custom"

    package { 'bugzilla':
        ensure => installed;
    }

    package { 'perl-Test-Taint':
       ensure => installed;
    }

    package { 'perl-JSON-RPC':
      ensure => installed;
    }

    $pgsql_password = extlookup("bugzilla_pgsql",'x')
    $ldap_password = extlookup("bugzilla_ldap",'x')

    @@postgresql::user { 'bugs':
        password => $pgsql_password,
    }

    @@postgresql::database { 'bugs':
        description => "Bugzilla database",
        user => "bugs",
        require => Postgresql::User['bugs']
    }

    file { '/etc/bugzilla/localconfig':
      ensure => present,
      owner => root,
      group => apache,
      mode => 640,
      content => template("bugzilla/localconfig")
    }


    file { '/var/lib/bugzilla/params':
      ensure => present,
      owner => root,
      group => apache,
      mode => 640,
      content => template("bugzilla/params")
    }

    apache::webapp_other{"bugzilla":
        webapp_file => "bugzilla/webapp_bugzilla.conf",
    }

    $bugs_vhost = "bugs.$domain"
    $vhost_root = "/usr/share/bugzilla/www"

    apache::vhost_redirect_ssl { "$bugs_vhost": }

    apache::vhost_base { "$bugs_vhost":
        aliases => { "/bugzilla/data" => "$lib_dir/bugzilla",
                     "/bugzilla/" => $vhost_root },  
        use_ssl => true,
        location => $vhost_root,
        vhost => $bugs_vhost,
    }

    subversion::snapshot { $bugzilla_location:
      source => "svn://svn.mageia.org/svn/web/templates/bugzilla/trunk"
    }

    file { "custom":
      path => "/usr/share/bugzilla/template/en/custom",
      ensure => directory,
      owner => root,
      group => apache,
      mode => 640,
      recurse => true,
      require => Subversion::Snapshot[$bugzilla_location]
    }
}
