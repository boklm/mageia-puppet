
class puppet {
    class client {
        package { puppet:
            ensure => installed
        }
    
        file { "puppet.conf":
            path => "/etc/puppet/puppet.conf",
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
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

    class master inherits client {
        package { puppet-server:
            ensure => installed
        }

        # for stored config
        $rails_package = $lsbdistid ? {
            Mageia => "ruby-rails",
            MandrivaLinux => "rails"
        }

        package { ["ruby-sqlite3",$rails_package]:
            ensure => installed
        }

        service { puppetmaster:
            ensure => running,
            path => "/etc/init.d/puppetmaster",
            subscribe => [ Package[puppet-server], File["puppet.conf"]]
        }

        file { "extdata":
            path => "/etc/puppet/extdata",
            ensure => directory,
            owner => puppet,
            group => puppet,
            mode => 700,
            recurse => true
        }

        file { '/etc/puppet/tagmail.conf':
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
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
