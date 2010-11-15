class bugzilla {

    package { bugzilla
        ensure => installed;
    }

    $password = extlookup("bugzilla_password")
    $passwordLdap = extlookup("bugzilla_ldap")

    file { '/etc/bugzilla/localconfig':
      ensure => present,
      owner => root,
      group => root,
      mode => 644,
      content => template("bugzilla/localconfig")
    }


    file { '/var/lib/bugzilla/params':
      ensure => present,
      owner => root,
      group => root,
      mode => 644,
      content => template("bugzilla/params")
    }
}

