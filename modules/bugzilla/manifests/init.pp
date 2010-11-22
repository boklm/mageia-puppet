class bugzilla {

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

    include apache::mod_fcgid
    apache::webapp_other{"bugzilla":
        webapp_file => "bugzilla/webapp_bugzilla.conf",
      }

    apache::vhost_other_app { "bugs.$domain":
      vhost_file => "bugzilla/vhost_bugs.conf",
    }
}

