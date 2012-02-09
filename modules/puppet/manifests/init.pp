
class puppet {
    class client {
        package { puppet: }
    
        file { "/etc/puppet/puppet.conf":
            content => template("puppet/puppet.conf"),
            require => Package[puppet]
        }

        cron { "puppet":
            command => "/usr/sbin/puppetd --onetime --no-daemonize --logdest syslog > /dev/null 2>&1",
            user => "root",
            minute => fqdn_rand( 60 ),
            ensure => present,
        }

        service { puppet:
            enable => false,
            hasstatus => true,
        }
    }

    class master {
        include puppet::client

        # for stored config
        $rails_package = $lsbdistid ? {
            Mageia => "ruby-rails",
            MandrivaLinux => "rails"
        }

        package { ["ruby-sqlite3", "puppet-server", $rails_package]: }

        service { puppetmaster:
            ensure => running,
            path => "/etc/init.d/puppetmaster",
            subscribe => [ Package[puppet-server], File["/etc/puppet/puppet.conf"]]
        }

        file { "/etc/puppet/extdata":
            ensure => directory,
            owner => puppet,
            group => puppet,
            mode => 700,
            recurse => true
        }

        file { '/etc/puppet/tagmail.conf':
            content => template("puppet/tagmail.conf"),
        }

        tidy { "/var/lib/puppet/reports":
            age     => "4w",
            matches => "*.yaml",
            recurse => true,
            type    => "mtime",
        }

        file { "/etc/puppet/autosign.conf":
            ensure =>  $environment ? {
                        'test' => 'present',
                        default =>  'absent',
            },
            content => '*',
        }
    }
}
