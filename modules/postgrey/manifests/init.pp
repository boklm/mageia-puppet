class postgrey {
    package { postgrey:
        ensure => installed
    }
    
    service { postgrey:
        ensure => running,
        path => "/etc/init.d/postgrey",
        subscribe => [ Package[postgrey]]
    }

    file { "/etc/sysconfig/postgrey":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("postgrey/postgrey.sysconfig"),
        notify => [ Service[postgrey] ],
        require => Package[postgrey],    
    }

    file { "/etc/postfix/postgrey_whitelist_clients.local":
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("postgrey/whitelist_clients.local"),
        require => Package[postgrey],
        notify => [ Service[postgrey]],
    }
}
