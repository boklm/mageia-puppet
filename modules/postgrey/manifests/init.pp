class postgrey {
    package { 'postgrey': }

    service { 'postgrey':
        subscribe => Package['postgrey'],
    }

    File {
        notify  => Service['postgrey'],
        require => Package['postgrey'],
    }

    file {
        '/etc/sysconfig/postgrey':
            content => template('postgrey/postgrey.sysconfig');
        '/etc/postfix/postgrey_whitelist_clients.local':
            content => template('postgrey/whitelist_clients.local');
    }
}
