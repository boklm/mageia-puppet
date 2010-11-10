class sympa {

    $package_list = ['sympa', 'sympa-www']

    package { $package_list:
        ensure => installed;
    }

    $password = extlookup("sympa_password")

    file { '/etc/sympa/sympa.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("sympa/sympa.conf")
    }

}

