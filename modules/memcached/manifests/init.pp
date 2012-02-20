class memcached {
    package { 'memcached': }

    service { 'memcached':
        require => Package['memcached'],
    }

    file { '/etc/sysconfig/memcached':
        require => Package['memcached'],
        source  => 'puppet:///modules/memcached/memcached.sysconfig',
        notify  => Service['memcached'],
    }
}
