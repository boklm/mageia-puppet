class puppet {
   class master {
        include puppet::client

        # rails and sqlite3 are used for stored config
        package { ['ruby-sqlite3', 'puppet-server', 'ruby-rails']: }

        service { puppetmaster:
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
