class mirror {
    class base {
	file { "/home/mirror/bin/":
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

    # For main Mageia mirror
    class main inherits base {
	file { "update_timestamp":
	    path => "/home/mirror/bin/update_timestamp",
	    ensure => present,
	    owner => mirror,
	    group => mirror,
	    mode => 755,
	    content => template("mirror/update_timestamp")
	}

	cron { mirror:
	    user => mirror,
	    hour => 10,
	    minute => 14,
	    command => "~mirror/bin/update_timestamp",
	    require => File["update_timestamp"],
	}
    }
}
