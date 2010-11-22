class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/iurt"

	include ssh::auth
	ssh::auth::key { $build_login: } # declare a key for build bot: RSA, 2048 bits
    }

    class mainnode inherits base {
        include iurtuser
        ssh::auth::server { $build_login: }

        package { "task-bs-cluster-main":
            ensure => "installed"
        }
    }

    class buildnode inherits base {
        include iurt
    }

    class scheduler {
        # ulri        
    }

    class dispatcher {
        # emi
    }
    
    class repsys {
        package { 'repsys':

        }


    }

    class iurtuser {
        group {"$build_login": 
            ensure => present,
        }

        user {"$build_login":
            ensure => present,
            comment => "System user used to run build bots",
            managehome => true,
            gid => $build_login,
            shell => "/bin/bash",
        }

        file { "$build_home_dir/.ssh":
            ensure => "directory",
            mode   => 600,
            owner  => $build_login,
            group  => $build_login,
        }
    }

    class iurt {
        include sudo
        include iurtuser
        ssh::auth::client { $build_login: }

        # build node common settings
        # we could have the following skip list to use less space:
        # '/(drakx-installer-binaries|drakx-installer-advertising|gfxboot|drakx-installer-stage2|mandriva-theme)/'
        $package_list = ['task-bs-cluster-chroot', 'iurt']
        package { $package_list:
            ensure => installed;
        }

        file { "$build_home_dir/.iurt.cauldron.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            content => template("buildsystem/iurt.cauldron.conf")
        }

        file { "/etc/sudoers.d/iurt":
            ensure => present,
            owner => root,
            group => root,
            mode => 440,
            content => template("buildsystem/sudoers.iurt")
        }
    }
}
