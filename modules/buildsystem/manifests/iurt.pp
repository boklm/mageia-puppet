class buildsystem {
    class iurt {
        include sudo
        include buildsystem::iurtuser
        $build_login = $buildsystem::base::build_login;
        $build_home_dir = $buildsystem::base::build_home_dir;

        ssh::auth::client { $build_login: }
        ssh::auth::server { $buildsystem::base::sched_login: user => $build_login }

        # remove old build directory
        tidy { "$build_home_dir/iurt":
            age => "8w",
            recurse => true,
            matches => ['[0-9][0-9].*\..*\..*\.[0-9]*',"log","*.rpm","*.log","*.mga[0-9]+"],
            rmdirs => true,
        }

        # build node common settings
        # we could have the following skip list to use less space:
        # '/(drakx-installer-binaries|drakx-installer-advertising|gfxboot|drakx-installer-stage2|mandriva-theme)/'
        $package_list = ['task-bs-cluster-chroot', 'iurt']
        package { $package_list: }

        file { "/etc/iurt/build":
            ensure => "directory",
        }

        define iurt_config() {

            $distribution = $name
            file { "/etc/iurt/build/$distribution.conf":
                owner => $build_login,
                group => $build_login,
                content => template("buildsystem/iurt.$distribution.conf")
            }
        }

        iurt_config { ["1","cauldron","mandriva2010.1"]: }

       	sudo::sudoers_config { "iurt":
            content => template("buildsystem/sudoers.iurt")
        }
    }
}
