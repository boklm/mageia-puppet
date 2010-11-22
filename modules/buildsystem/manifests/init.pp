class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/$build_login"
        $sched_login = "schedbot"
	$sched_home_dir = "/home/$sched_login"

	include ssh::auth
	ssh::auth::key { $build_login: } # declare a key for build bot: RSA, 2048 bits
	ssh::auth::key { $sched_login: } # declare a key for sched bot: RSA, 2048 bits
    }

    class mainnode inherits base {
        include iurtuser
        ssh::auth::client { $sched_login: }
        ssh::auth::server { $build_login: }

        sshuser { $sched_login:
          homedir => $sched_home_dir,
          comment => "System user used to schedule builds",
        }

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

    define sshuser($homedir, $comment) {
        group {"$title": 
            ensure => present,
        }

        user {"$title":
            ensure => present,
            comment => $comment,
            managehome => true,
            gid => $title,
            shell => "/bin/bash",
            notify => Exec["unlock$title"],
        }

        # set password to * to unlock the account but forbid login through login
        exec { "unlock$title":
            command => "usermod -p '*' $title",
            refreshonly => true,
        }

        file { $homedir:
            ensure => "directory",
        }

        file { "$homedir/.ssh":
            ensure => "directory",
            mode   => 600,
            owner  => $title,
            group  => $title,
        }
    }

    class iurtuser {
        sshuser { $build_login:
          homedir => $build_home_dir,
          comment => "System user used to run build bots",
        }
    }

    class iurt {
        include sudo
        include iurtuser
        ssh::auth::client { $build_login: }
        ssh::auth::server { $sched_login: user => $build_login }

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
