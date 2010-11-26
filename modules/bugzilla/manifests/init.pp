class bugzilla {

   $bugzilla_location = "/usr/share/bugzilla/template/en/custom"

    package { 'bugzilla':
        ensure => installed;
    }

    $password = extlookup("bugzilla_password",'x')
    $passwordLdap = extlookup("bugzilla_ldap",'x')

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

    apache::vhost_other_app { "bugs.$domain":
      vhost_file => "bugzilla/vhost_bugs.conf",
    }

    file { "custom":
      path => "/usr/share/bugzilla/template/en/custom",
      ensure => directory,
      owner => root,
      group => apache,
      mode => 700,
      recurse => true,
      require => Subversion::Snapshot[$bugzilla_location]
    }

    subversion::snapshot { $bugzilla_location:
      source => "svn://svn.mageia.org/svn/web/templates/bugzilla/trunk"
    }
}
