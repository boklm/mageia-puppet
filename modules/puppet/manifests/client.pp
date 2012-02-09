class puppet::client {
    package { puppet: }

    file { "/etc/puppet/puppet.conf":
        content => template("puppet/puppet.conf"),
        require => Package[puppet]
    }

    cron { "puppet":
        command => "/usr/sbin/puppetd --onetime --no-daemonize --logdest syslog > /dev/null 2>&1",
        user => "root",
        minute => fqdn_rand( 60 ),
        ensure => present,
    }

    # we are using cron, so no need for the service
    service { puppet:
        enable => false,
        hasstatus => true,
    }
}

 
