class bind {
    class bind_base {
        package { bind:
            ensure => installed
        }

        service { named:
            ensure => running,
            path => "/etc/init.d/named",
            subscribe => [ Package["bind"]]
        }
    }

    file { '/etc/named.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["bind"],
        content => "",
        notify => [Service['named']]
    }

    define zone_master {
        file { "/var/lib/named/var/named/master/$name.zone":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("bind/zones/$name.zone"),
            require => Package[bind],
            notify => Service[named]
        }
    }

    class bind_master inherits bind_base {
        file { '/etc/named.conf':
            content => template("bind/named_base.conf", "bind/named_master.conf"),
        }
    }

    class bind_slave inherits bind_base {
        file { '/etc/named.conf':
            content => template("bind/named_base.conf", "bind/named_slave.conf"),
        }
    }

}
