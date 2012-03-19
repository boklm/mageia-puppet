class mirror {
    class base {
        $bindir = '/usr/local/bin'
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

}
