class sympa {

    $package_list = ['sympa', 'sympa-www']

    package { $package_list:
        ensure => installed;
    }

    $password = extlookup("sympa_password")
    $ldappass = extlookup("sympa_ldap")

    file { '/etc/sympa/sympa.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("sympa/sympa.conf")
    }

    file { '/etc/sympa/ldap_alias_manager.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("sympa/ldap_alias_manager.conf")
    }
}

