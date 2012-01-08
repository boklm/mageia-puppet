class ntp {
    package { ntp: }

    service { ntpd:
        ensure => running,
        path => "/etc/init.d/ntpd",
        subscribe => [Package["ntp"], File["/etc/ntp.conf"]],
    }

    file { "/etc/ntp.conf":
        require => Package["ntp"],
        content => template("ntp/ntp.conf"),
    }
}
