class dashboard {
    class variable {
        $dashboard_login = "dashboard"
        $dashboard_home_dir = "/var/lib/$dashboard_login"
        $dashboard_dir = "$dashboard_home_dir/dashboard"
    }

    class base inherits variable {
        user {"$dashboard_login":
            ensure => present,
            comment => "dashboard system user",
            managehome => true,
            home => $dashboard_home_dir,
            gid => $dashboard_login,
            shell => "/bin/bash",
        }

	subversion::snapshot { $dashboard_dir:
	    source => "svn://svn.$domain/soft/dashboard/",
	}
    }
}
