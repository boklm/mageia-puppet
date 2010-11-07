class bugzilla {

    package { bugzilla
        ensure => installed;
    }

    file { '/etc/bugzilla/localconfig':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("bugzilla/localconfig")
    }

}

