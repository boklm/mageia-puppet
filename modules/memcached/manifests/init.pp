class memcached {
    package { "memcached":

    }

    service { "memcached":
        ensure => running,
        path => "/etc/init.d/memcached",
        subscribe => [ Package["memcached"] ]
    }

    file { "/etc/sysconfig/memcached":
         ensure => present,
         owner => root,
         group => root,
         mode => 644,
         require => Package["memcached"],
         source => "puppet:///modules/memcached/memcached.sysconfig",
         notify => Service["memcached"]
    }

}
