class rsyncd($rsyncd_conf = 'rsyncd/rsyncd.conf') {

    xinetd::service { "rsync":
        content => template("rsyncd/xinetd")
    }

    file { "rsyncd.conf":
        path => "/etc/rsyncd.conf",
        require => Package["rsync"],
        content => template($rsyncd_conf)
    }
}
