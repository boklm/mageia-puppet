class draklive {
    class variable {
        $draklive_login = 'draklive'
        $draklive_home = '/home/draklive'
        $draklive_config = "$draklive_home/live-config"
        $draklive_var_data = "$draklive_home/var-data"
	$isomakers_group = 'mga-iso_makers'
    }

    class base inherits variable {
	include sudo

        group { $draklive_login: }
 
        user { $draklive_login:
            homedir => $draklive_home,
            comment => 'User for creating live ISOs',
        }

        package { draklive:
	    ensure => 'installed',
        }

        sudo::sudoers_config { "draklive":
	    content => template("draklive/sudoers.draklive")
        }

	file { $draklive_var_data:
	    ensure => directory,
	    owner => $draklive_login,
	    group => $draklive_login,
	    mode => 755,
	}

	file { "/var/lib/draklive":
	     ensure => symlink,
	     target => $draklive_var_data,
	}

        subversion::snapshot { $draklive_config:
            source => "svn://svn.$domain/soft/images-config/draklive/trunk/",
        }

        cron { "build live images":
            command => "$draklive_config/tools/build_live.sh",
            user => $draklive_login,
            hour => "4",
            minute => "30",
        }

        file { "/usr/local/bin/clean-live.sh":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/draklive/clean-live.sh",
        }
    
        cron { "clean live build data":
            command => "/usr/local/bin/clean-live.sh",
            hour => "4",
            minute => "20",
        }
    }
}
