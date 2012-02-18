class buildsystem { 
    class mgarepo {
        package { ['mgarepo','rpm-build']: }

        file {
            "/etc/mgarepo.conf": content => template("buildsystem/mgarepo.conf");
            "/etc/repsys.conf": content => template("buildsystem/mgarepo.conf");
        }

        file { "$packages_archivedir":
            ensure => "directory",
            owner  => $sched_login,
            require => File[$sched_home_dir],
        }

        file { "$sched_home_dir/repsys":
            ensure => "directory",
            owner  => $sched_login,
            require => File[$sched_home_dir],
        }

        file { ["$sched_home_dir/repsys/tmp", "$sched_home_dir/repsys/srpms"]:
            ensure => "directory",
            owner  => $sched_login,
            group => "mga-packagers",
            mode => 1775,
            require => File["$sched_home_dir/repsys"],
        }

        # FIXME: disabled temporarly as upload dir is a symlink to /var/lib/repsys/uploads
        #file { "$sched_home_dir/uploads":
        #    ensure => "directory",
        #    owner  => $sched_login,
        #    require => File[$sched_home_dir],
        #}

        $releases = {
            'cauldron' => { 
                'core' => ['release','updates_testing','backports_testing','backports','updates'],
                'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
                'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
            },
            '1' => { 
                'core' => ['release','updates_testing','backports_testing','backports','updates'],
                'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
                'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
            },
            'infra_1' => { 
                'infra' => ['release']
            },
        }         

        import "create_upload_dir.rb"
        create_upload_dir { "$sched_home_dir/uploads":
            owner => $sched_login, 
            group => $sched_login,
            releases => $releases,
        } 

        Tidy {
            recurse => true,
            type    => "ctime",
        }

        tidy { "$sched_home_dir/uploads":
            age     => "2w",
        }

        tidy { "$packages_archivedir":
            age     => "1w",
            matches => "*.rpm",
        }
    }
}

