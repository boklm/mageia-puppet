class buildsystem::base {

    $sched_login = 'schedbot'
    $sched_home_dir = "/var/lib/$sched_login"

    $packagers_group = 'mga-packagers'
    $packagers_committers_group = 'mga-packagers-committers'

    include ssh::auth
    ssh::auth::key { $buildsystem::iurt::user::login:
        # declare a key for build bot: RSA, 2048 bits
        home => $buildsystem::iurt::user::homedir,
    }

    ssh::auth::key { $sched_login:
        # declare a key for sched bot: RSA, 2048 bits
        home => $sched_home_dir,
    }
}
