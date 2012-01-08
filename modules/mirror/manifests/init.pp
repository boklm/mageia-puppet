class mirror {
    class base {
        $locksdir = '/home/mirror/locks'

        file { "$locksdir":
            ensure => directory,
            owner => mirror,
            group => mirror,
        }

        group {"mirror": }

        user {"mirror":
            comment => "System user use to run mirror scripts",
            gid => mirror,
        }
    }

    define mirrordir ($remoteurl, $localdir, $rsync_options="-avH --delete") {
    	include base
        $lockfile = "$locksdir/$name"

        file { "$localdir":
            ensure => directory,
            owner => mirror,
            group => mirror,
        }

    	local_script { "mirror_$name":
            content => template("mirror/mirrordir"),
        }

        cron { "mirror_$name":
            user => mirror,
            minute => '*/10',
            command => "$bindir/mirror_$name",
            require => Local_script["mirror_$name"],
        }
    }

    # For main Mageia mirror
    class main inherits base {
        local_script { "update_timestamp":
            content => template("mirror/update_timestamp")
        }

        cron { mirror:
            user => mirror,
            minute => '*/10',
            command => "/usr/local/bin/update_timestamp",
            require => [Local_script["update_timestamp"], User['mirror']],
        }
    }

    class mageia inherits base {
    	mirrordir { "mageia":
            remoteurl => "rsync://rsync.$domain/mageia",
            localdir => '/distrib/mageia',
        }
    }

    class newrelease inherits base {
    	mirrordir { "newrelease":
            remoteurl => "rsync://rsync.$domain/newrelease",
            localdir => '/distrib/newrelease',
	    }
    }

    class mdv2010spring inherits base {
    	mirrordir { "mdv2010.1":
            remoteurl => "rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/MandrivaLinux/official/2010.1",
            localdir => '/distrib/mandriva/',
        }
    }
}
