class rsyncd {

    xinetd::service { "rsync":
        content => template("rsyncd/xinetd")
    }

    file { "rsyncd.conf":
        path => "/etc/rsyncd.conf",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["rsync"],
        content => template("rsyncd/rsyncd.conf")
    }
}
