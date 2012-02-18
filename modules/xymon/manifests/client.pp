class xymon::client {
    package { 'xymon-client': }

    service { 'xymon-client':
        hasstatus => false,
        status    => '/usr/lib64/xymon/client/runclient.sh status',
        require   => Package['xymon-client'],
    }

    # TODO replace with a exported ressource
    $server = extlookup('hobbit_server','x')
    file { '/etc/sysconfig/xymon-client':
        content => template('xymon/xymon-client'),
        notify  => Service['xymon-client'],
        require => Package['xymon-client'],
    }
}
