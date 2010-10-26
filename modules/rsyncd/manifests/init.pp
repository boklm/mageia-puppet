class rsyncd {

    package { xinetd:
        ensure => installed
    }

    service { xinetd:
        ensure => running,
        path => "/etc/init.d/xinetd",
        subscribe => [ Package["xinetd"], File["xinetd"] ]
    }
    
    file { "rsync":
        path => "/etc/xinetd.d/rsync",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => "xinetd",
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
