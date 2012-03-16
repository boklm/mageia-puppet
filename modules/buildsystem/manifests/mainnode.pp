class buildsystem::mainnode {
    include buildsystem::base
    include buildsystem::iurtuser
    $sched_login = $buildsystem::base::sched_login
    $sched_home_dir = $buildsystem::base::sched_home_dir
    $build_login = $buildsystem::base::build_login
    $repository_root = $buildsystem::base::repository_root

    sshuser { $sched_login:
        homedir => $sched_home_dir,
        comment => 'System user used to schedule builds',
    }

    ssh::auth::client { $sched_login: }

    ssh::auth::server { [$sched_login, $build_login]: }

    # FIXME Add again task-bs-cluster-main when it will require
    # mgarepo instead of repsys
    $package_list = ['iurt']
    package { $package_list: }

    $mirror_root = '/distrib/mirror'
    apache::vhost_other_app { "repository.$::domain":
        vhost_file => 'buildsystem/vhost_repository.conf',
    }

    $location = '/var/www/bs'
    file { [$location,"$location/data"]:
        ensure => directory,
    }

    apache::vhost_base { "pkgsubmit.$::domain":
        aliases  => { '/uploads' => "$sched_home_dir/uploads" },
        location => $location,
        content  => template('buildsystem/vhost_pkgsubmit.conf'),
    }

    subversion::snapshot { $location:
        source => "svn://svn.$::domain/soft/buildsystem/web/",
    }

    file { $repository_root:
        ensure => directory,
    }

    buildsystem::media_cfg { ['i586','x86_64']: }

    include buildsystem::scheduler
    include buildsystem::gatherer
    include buildsystem::mgarepo
    include buildsystem::signbot
    include buildsystem::youri_submit

    cron { 'dispatch jobs':
        user    => $sched_login,
        command => 'ulri; emi',
        minute  => '*',
    }
}
