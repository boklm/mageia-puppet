class buildsystem::pkgsubmit {
    include buildsystem::scheduler::var
    $sched_home_dir = $buildsystem::scheduler::var::homedir

    $location = '/var/www/bs'
    file { [$location,"$location/data"]:
        ensure => directory,
    }

    apache::vhost::base { "pkgsubmit.$::domain":
        aliases  => { '/uploads' => "$sched_home_dir/uploads" },
        location => $location,
        content  => template('buildsystem/vhost_pkgsubmit.conf'),
    }

    subversion::snapshot { $location:
        source => "svn://svn.$::domain/soft/buildsystem/web/",
    }
}
