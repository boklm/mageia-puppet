class ssmtp {
    package { ssmtp:
        ensure => installed,
    }

    file { "ssmtp.conf":
        path => "/etc/ssmtp/ssmtp.conf",
        owner => root,
        group => root,
        mode => 644,
        content => template("ssmtp/ssmtp.conf")
    }
}
