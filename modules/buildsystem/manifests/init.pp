class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/$build_login"
        $sched_login = "schedbot"
	$sched_home_dir = "/home/$sched_login"

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

    define sshuser($user, $homedir, $comment) {
        group {"$user": 
            ensure => present,
        }

        user {"$user":
            ensure => present,
            comment => $comment,
            managehome => true,
            gid => $user,
            shell => "/bin/bash",
            notify => Exec["unlock$user"],
        }

        # set password to * to unlock the account but forbid login through login
        exec { "unlock$user":
            command => "usermod -p '*' $user",
            refreshonly => true,
        }

        file { $homedir:
            ensure => "directory",
        }

        file { "$homedir/.ssh":
            ensure => "directory",
            mode   => 600,
            owner  => $user,
            group  => $user,
        }
    }

    class iurtuser {
        sshuser($build_login, $build_home_dir, "System user used to run build bots")
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
