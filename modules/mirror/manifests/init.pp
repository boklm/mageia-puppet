class mirror {
    class base {
	$bindir = '/usr/local/bin'
	$locksdir = '/home/mirror/locks'
	file { "$bindir":
	    ensure => directory,
            owner => root,
	    group => root,
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
	    path => "$bindir/mirror_$name",
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template("mirror/mirrordir"),
	}

	cron { "mirror_$name":
	    user => mirror,
	    minute => [0, 10, 20, 30, 40, 50],
	    command => "$bindir/mirror_$name",
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
	    minute => [0, 10, 20, 30, 40, 50],
	    command => "$bindir/update_timestamp",
	    require => File["update_timestamp"],
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
