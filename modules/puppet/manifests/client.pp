class puppet::client inherits puppet {

    cron { 'puppet':
        ensure  => present,
        command => '/usr/sbin/puppetd -o --no-daemonize -l syslog >/dev/null 2>&1',
        user    => 'root',
        minute  => fqdn_rand( 60 ),
    }

    # we are using cron, so no need for the service
    service { 'puppet':
        enable    => false,
        hasstatus => true,
    }
}
