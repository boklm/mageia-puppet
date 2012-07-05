class buildsystem::mainnode {
    include buildsystem::base
    include buildsystem::iurt::user
    include buildsystem::scheduler
    include buildsystem::gatherer
    include buildsystem::mgarepo
    include buildsystem::signbot
    include buildsystem::youri_submit

    $sched_login    = $buildsystem::scheduler::var::login
    $sched_home_dir = $buildsystem::scheduler::var::homedir

    $build_login = $buildsystem::iurt::user::login

    ssh::auth::client { $sched_login: }

    ssh::auth::server { [$sched_login, $build_login]: }

    $mirror_root = '/distrib/mirror'
    apache::vhost::other_app { "repository.$::domain":
        vhost_file => 'buildsystem/vhost_repository.conf',
    }

    buildsystem::media_cfg { ['i586','x86_64']: }
}
