class cron {
    package { "cronie": }

    service { crond:
        ensure => running,
        subscribe => [ Package["cronie"] ]
    }
}
