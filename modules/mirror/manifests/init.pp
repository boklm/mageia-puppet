class mirror {
    class base {
	$bindir = '/home/mirror/bin'
	$locksdir = '/home/mirror/locks'
	file { "$bindir":
	    ensure => directory,
            owner => mirror,
	    group => mirror,
	    mode => 755
	}

	file { "$locksdir":
	    ensure => directory,
            owner => mirror,
	    group => mirror,
	    mode => 755
	}

	group {"mirror":
	    ensure => present,
	}

	user {"mirror":
	    ensure => present,
		   comment => "System user use to run mirror scripts",
		   managehome => true,
		   gid => mirror,
		   shell => "/bin/bash",
	}
    }

    define mirrordir ($remoteurl, $localdir, $rsync_options="-avH --delete") {
    	include base
	$lockfile = "$locksdir/$name"
	file { "$localdir":
	    ensure => directory,
            owner => mirror,
	    group => mirror,
	    mode => 755,
	}
    	file { "mirror_$name":
	    path => "$bindir/$name",
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template("mirror/mirrordir"),
	}

	cron { "mirror_$name":
	    user => mirror,
	    minute => [0, 10, 20, 30, 40, 50],
	    command => "$bindir/$name",
	    require => File["mirror_$name"],
	}
    }

    # For main Mageia mirror
    class main inherits base {
	file { "update_timestamp":
	    path => "$bindir/update_timestamp",
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template("mirror/update_timestamp")
	}

	cron { mirror:
	    user => mirror,
	    hour => 10,
	    minute => 14,
	    command => "$bindir/update_timestamp",
	    require => File["update_timestamp"],
	}
    }

    class mirrorbootstrap inherits base {
    	mirrordir { "bootstrap":
	    remoteurl => 'rsync://valstar.mageia.org/bootstrap',
	    localdir => '/distrib/bootstrap',
	}
    }
}
