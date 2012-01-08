class memcached {
    package { "memcached": }

    service { "memcached":
        ensure => running,
        path => "/etc/init.d/memcached",
        subscribe => [ Package["memcached"] ]
    }

    file { "/etc/sysconfig/memcached":
        require => Package["memcached"],
        source => "puppet:///modules/memcached/memcached.sysconfig",
        notify => Service["memcached"],
    }
}
