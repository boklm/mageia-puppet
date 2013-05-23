class buildsystem::webstatus {
    include buildsystem::var::webstatus
    include buildsystem::var::scheduler
    $sched_home_dir = $buildsystem::var::scheduler::homedir

    $location = '/var/www/bs'
    file { [$location,"$location/data"]:
        ensure => directory,
    }

    apache::vhost::base { $buildsystem::var::webstatus::hostname:
        aliases  => {
            '/uploads' => "$sched_home_dir/uploads",
            '/autobuild/cauldron/x86_64/core/log/status.core.log' => "$location/autobuild/broken.php"
        },
        location => $location,
        content  => template('buildsystem/vhost_webstatus.conf'),
    }

    subversion::snapshot { $location:
        source => $buildsystem::var::webstatus::svn_url,
    }
}
