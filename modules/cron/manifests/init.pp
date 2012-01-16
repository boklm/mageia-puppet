class cron {
    package { "cronie": }

    service { crond:
        subscribe => Package["cronie"],
    }
}
