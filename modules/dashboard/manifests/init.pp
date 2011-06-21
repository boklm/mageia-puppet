class dashboard {
    class variable {
        $dashboard_login = "dashboard"
        $dashboard_home_dir = "/var/lib/$dashboard_login"
        $dashboard_dir = "$dashboard_home_dir/dashboard"
        $dashboard_bindir = "$dashboard_home_dir/bin"
	$dashboard_wwwdir = "/var/www/vhosts/dashboard.$domain"
    }

    class base inherits variable {
        user {"$dashboard_login":
            ensure => present,
            comment => "dashboard system user",
            managehome => true,
            home => $dashboard_home_dir,
            shell => "/bin/bash",
        }

	subversion::snapshot { $dashboard_dir:
	    source => "svn://svn.$domain/soft/dashboard/",
	}

	package { "php-cli":
	    ensure => 'installed',
	}

	file { $dashboard_wwwdir:
	    ensure => directory,
	    owner => $dashboard_login,
	    group => $dashboard_login,
	    mode => 755,
	}

	file { $dashboard_bindir:
	    ensure => directory,
	    owner => root,
	    group => root,
	    mode => 755,
	}

	file { "$dashboard_bindir/make_report":
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template('dashboard/make_report'),
	}

	apache::vhost_base { "dashboard.$domain":
	    location => $dashboard_wwwdir,
	}

	cron { "update dashboard":
	    command => "$dashboard_bindir/make_report",
	    user => $dashboard_login,
	    hour => "*/2",
	    minute => '15',
	}
    }
}
