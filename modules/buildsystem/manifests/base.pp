class buildsystem::base {
    include buildsystem::scheduler::var

    $sched_login = $buildsystem::scheduler::var::login
    $sched_home_dir = $buildsystem::scheduler::var::homedir

    $packagers_group = 'mga-packagers'
    $packagers_committers_group = 'mga-packagers-committers'

    include ssh::auth
    ssh::auth::key { $buildsystem::iurt::user::login:
        # declare a key for build bot: RSA, 2048 bits
        home => $buildsystem::iurt::user::homedir,
    }

}
