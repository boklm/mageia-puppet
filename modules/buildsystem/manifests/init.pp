class buildsystem {

    class buildnode {
        include iurt
    }

    class iurt {
        include sudo

        $home_dir = "/home/buildbot/"
        $build_login = "buildbot"
        # build node common settings
        # we could have the following skip list to use less space:
        # '/(drakx-installer-binaries|drakx-installer-advertising|gfxboot|drakx-installer-stage2|mandriva-theme)/'
        $package_list = ['task-bs-cluster-chroot', 'iurt']
        package { $package_list:
            ensure => installed;
        }

        file { "$home_dir/.iurt.cauldron.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            content => template("iurt/iurt.cauldron.conf")
        }

        file { "/etc/sudoers.d/iurt":
            ensure => present,
            owner => root,
            group => root,
            mode => 600,
            content => template("iurt/sudoers.iurt")
        }

        group {"$build_login": 
            ensure => present,
        }

        user {"$build_login":
            ensure => present,
            comment => "System user use to run build bots"    
            managehome => true,
            shell => "/bin/bash",
        }
    }
}
