class mirror {

    file { "update_timestamp":
        path => "/home/mirror/bin/update_timestamp",
        ensure => present,
        owner => mirror,
        group => mirror,
        mode => 755,
        content => template("mirror/update_timestamp")
    }

    cron { mirror:
        user => mirror,
        hour => 10,
        minute => 14,
        command => "~mirror/bin/update_timestamp",
        require => File["update_timestamp"],
    }

}
