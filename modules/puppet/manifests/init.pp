
class puppet {
    class client {
        package { puppet:
            ensure => installed
        }
    
        service { puppet:
            ensure => running,
            subscribe => [ Package[puppet], File["/etc/puppet/puppet.conf"]]
        }

        file { "/etc/puppet/puppet.conf":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("puppet/puppet.conf"),
            require => Package[puppet]
        }
    }

    class master inherits client {
        package { puppet-server:
            ensure => installed
        }
    
        service { puppetmaster:
            ensure => running,
            path => "/etc/init.d/puppetmaster",
            subscribe => [ Package[puppet-server], File["/etc/puppet/puppet.conf"]]
        }
    }
}
