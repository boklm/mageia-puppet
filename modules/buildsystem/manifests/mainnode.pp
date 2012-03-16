class buildsystem::mainnode {
    include buildsystem::base
    include buildsystem::iurt::user
    include buildsystem::scheduler
    include buildsystem::gatherer
    include buildsystem::mgarepo
    include buildsystem::signbot
    include buildsystem::youri_submit

    $sched_login    = $buildsystem::scheduler::login
    $sched_home_dir = $buildsystem::scheduler::homedir

    $build_login = $buildsystem::iurt::user::login
    $repository_root = $buildsystem::base::repository_root

    ssh::auth::client { $sched_login: }

    ssh::auth::server { [$sched_login, $build_login]: }

    $mirror_root = '/distrib/mirror'
    apache::vhost_other_app { "repository.$::domain":
        vhost_file => 'buildsystem/vhost_repository.conf',
    }

   file { $repository_root:
        ensure => directory,
    }

    buildsystem::media_cfg { ['i586','x86_64']: }

    cron { 'dispatch jobs':
        user    => $sched_login,
        command => 'ulri; emi',
        minute  => '*',
    }
}
