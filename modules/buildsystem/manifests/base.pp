class buildsystem::base {
    $build_login = 'iurt'
    $build_home_dir = "/home/$build_login"
    $sched_login = 'schedbot'
    $sched_home_dir = "/var/lib/$sched_login"
    $packages_archivedir = "$sched_home_dir/old"
    $repository_root = '/distrib/bootstrap'
    $packagers_group = 'mga-packagers'
    $packagers_committers_group = 'mga-packagers-committers'

    include ssh::auth
    ssh::auth::key { $build_login:
        # declare a key for build bot: RSA, 2048 bits
        home => $build_home_dir,
    }

    ssh::auth::key { $sched_login:
        # declare a key for sched bot: RSA, 2048 bits
        home => $sched_home_dir,
    }
}
