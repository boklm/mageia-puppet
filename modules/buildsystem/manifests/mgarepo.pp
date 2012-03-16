class buildsystem::mgarepo {
    $sched_home_dir = $buildsystem::base::sched_home_dir
    $sched_login =    $buildsystem::base::sched_login

    package { ['mgarepo','rpm-build']: }

    file {
        '/etc/mgarepo.conf': content => template('buildsystem/mgarepo.conf');
        '/etc/repsys.conf':  content => template('buildsystem/mgarepo.conf');
    }

    file { "$sched_home_dir/repsys":
        ensure  => 'directory',
        owner   => $sched_login,
        require => File[$sched_home_dir],
    }

    file { ["$sched_home_dir/repsys/tmp", "$sched_home_dir/repsys/srpms"]:
        ensure  => 'directory',
        owner   => $sched_login,
        group   => 'mga-packagers',
        mode    => '1775',
        require => File["$sched_home_dir/repsys"],
    }

    # FIXME: disabled temporarly as upload dir is a symlink to /var/lib/repsys/uploads
    #file { "$sched_home_dir/uploads":
    #    ensure  => "directory",
    #    owner   => $sched_login,
    #    require => File[$sched_home_dir],
    #}

    #FIXME This config information should be moved out of this class
    $releases = {
        'cauldron' => {
            'core'    => ['release','updates_testing','backports_testing','backports','updates'],
            'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
            'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
        },
        '1'        => {
            'core'    => ['release','updates_testing','backports_testing','backports','updates'],
            'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
            'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
        },
        'infra_1'  => {
            'infra' => ['release']
        },
    }

    import 'create_upload_dir.rb'
    create_upload_dir { "$sched_home_dir/uploads":
        owner    => $sched_login,
        group    => $sched_login,
        releases => $releases,
    }

    tidy { "$sched_home_dir/uploads":
        type    => 'ctime',
        recurse => true,
        age     => '2w',
    }

}
