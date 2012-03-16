class buildsystem::base {

    $sched_login = $buildsystem::scheduler::login
    $sched_home_dir = "/var/lib/$sched_login"

    $packagers_group = 'mga-packagers'
    $packagers_committers_group = 'mga-packagers-committers'

    include ssh::auth
    ssh::auth::key { $buildsystem::iurt::user::login:
        # declare a key for build bot: RSA, 2048 bits
        home => $buildsystem::iurt::user::homedir,
    }

}
