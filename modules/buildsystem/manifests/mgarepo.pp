class buildsystem { 
    class mgarepo {
        package { ['mgarepo','rpm-build']: }

        file { "mgarepo.conf":
            path => "/etc/mgarepo.conf",
            owner  => root,
            group => root,
            mode => 644,
            content => template("buildsystem/mgarepo.conf")
        }

        file { "repsys.conf":
            path => "/etc/repsys.conf",
            owner  => root,
            group => root,
            mode => 644,
            content => template("buildsystem/mgarepo.conf")
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

        # too tedious to create everything by hand
        # so I prefered to used some puppet ruby module
        # the exact content and directory name should IMHO be consolidated somewhere
        import "create_upload_dir.rb"
        create_upload_dir { "$sched_home_dir/uploads":
            owner => $sched_login, 
            group => $sched_login,
        } 

        tidy { "$sched_home_dir/uploads":
            age     => "2w",
            recurse => true,
            type    => "ctime",
        }

        tidy { "$packages_archivedir":
            age     => "1w",
            matches => "*.rpm",
            recurse => true,
            type    => "ctime",
        }
    }
}

