class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/iurt/"
    }

    class mainnode inherits base {
        include iurtuser

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
            comment => "System user use to run build bots",
            managehome => true,
            gid => $build_login,
            shell => "/bin/bash",
        }
    }

    class iurt {
        include sudo
        include iurtuser

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
