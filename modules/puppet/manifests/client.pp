class puppet::client {
    include puppet::stored_config

    package { 'puppet': }

    file { '/etc/puppet/puppet.conf':
        content => template('puppet/puppet.conf','puppet/puppet.agent.conf'),
        require => Package[puppet],
    }

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
