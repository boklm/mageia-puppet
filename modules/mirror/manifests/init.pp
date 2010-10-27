class mirror {

    file { "update_timestamp":
        path => "/home/mirror/bin/update_timestamp",
        ensure => present,
        owner => mirror,
        group => mirror,
        mode => 755,
        content => template("mirror/update_timestamp")
    }

    file { "mirror.cron":
        path => "/etc/cron.d/mirror",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => File["update_timestamp"],
        content => template("mirror/cron")
    }

}
