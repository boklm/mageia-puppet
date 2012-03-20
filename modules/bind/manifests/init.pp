class bind {
    package { 'bind': }

    service { 'named':
        restart   => 'service named restart',
        subscribe => Package['bind'],
    }

    file { '/etc/named.conf':
        ensure  => link,
        target  => '/var/lib/named/etc/named.conf',
        require => Package['bind'],
    }

    exec { 'named_reload':
        command     => 'service named reload',
        refreshonly => true,
    }

    file { '/var/lib/named/etc/named.conf':
        require => Package['bind'],
        content => '',
        notify  => Service['named'],
    }
}
