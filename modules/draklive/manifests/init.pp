class draklive {
    class variable {
        $draklive_login = 'draklive'
        $draklive_home = '/home/draklive'
	$isomakers_group = 'mga-iso_makers'
    }

    class base inherits variable {
	include sudo

        buildsystem::sshuser { $draklive_login:
            homedir => $draklive_home,
            comment => "User for creating live ISOs",
	}

        package { draklive:
	    ensure => 'installed',
        }

        sudo::sudoers_config { "draklive":
	    content => template("draklive/sudoers.draklive")
        }

	file { "$draklive_home/var-data":
	    ensure => directory,
	    owner => $draklive_login,
	    group => $draklive_login,
	    mode => 755,
	}

	file { "/var/lib/draklive":
	     ensure => symlink,
	     target => "$draklive_home/var-data",
	}

        subversion::snapshot { "/etc/draklive":
            source => "svn://svn.$domain/soft/images-config/draklive/trunk/",
        }
    }
}
