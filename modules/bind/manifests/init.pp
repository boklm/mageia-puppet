class bind {
    class bind_base {
        package { bind:
            ensure => installed
        }

        service { named:
            ensure => running,
            restart => "service named restart", 
            subscribe => [ Package["bind"]]
        }

        file { '/etc/named.conf':
            ensure => "/var/lib/named/etc/named.conf",
            owner => root,
            group => root,
            mode => 644,
            require => Package[bind]
        }
        
        exec { "named_reload":
            command => "service named reload":
            refreshonly => true,
        } 
    }

    file { '/var/lib/named/etc/named.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["bind"],
        content => "",
        notify => [Service['named']]
    }

    define zone_base($content = false) {
        if ! $content {
            $zone_content = template("bind/zones/$name.zone")
        } else {
            $zone_content = $content
        }
        file { "/var/lib/named/var/named/$zone_subdir/$name.zone":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => $zone_content,
            require => Package[bind],
            notify => Exec[named_reload]
        }
    }

    define zone_master($content = false) {
        $zone_subdir = "master"
        zone_base { $name : 
            content => $content 
        }
    }

    define zone_reverse($content = false) {
        $zone_subdir = "reverse"
        zone_base { $name : 
            content => $content 
        } 
    }


    class bind_master inherits bind_base {
        Tld_redirections::Domain <<| |>>

        $managed_tlds = list_exported_ressources('Tld_redirections::Domain')
        file { '/var/lib/named/etc/named.conf':
            content => template("bind/named_base.conf", "bind/named_master.conf"),
        }
    }

    class bind_slave inherits bind_base {
        $managed_tlds = list_exported_ressources('Tld_redirections::Domain')
        file { '/var/lib/named/etc/named.conf':
            content => template("bind/named_base.conf", "bind/named_slave.conf"),
        }
    }

}
