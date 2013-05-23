class buildsystem::mgarepo {
    include buildsystem::var::scheduler
    include buildsystem::var::groups
    include buildsystem::var::binrepo
    include buildsystem::create_upload_dir
    $sched_login = $buildsystem::var::scheduler::login
    $sched_home_dir = $buildsystem::var::scheduler::homedir

    package { ['mgarepo','rpm-build']: }

    file { '/etc/mgarepo.conf':
	content => template('buildsystem/mgarepo.conf'),
    }

    file { "$sched_home_dir/repsys":
        ensure  => 'directory',
        owner   => $sched_login,
        require => File[$sched_home_dir],
    }

    file { ["$sched_home_dir/repsys/tmp", "$sched_home_dir/repsys/srpms"]:
        ensure  => 'directory',
        owner   => $sched_login,
        group   => $buildsystem::var::groups::packagers,
        mode    => '1775',
        require => File["$sched_home_dir/repsys"],
    }

    # FIXME: disabled temporarly as upload dir is a symlink to /var/lib/repsys/uploads
    #file { "$sched_home_dir/uploads":
    #    ensure  => "directory",
    #    owner   => $sched_login,
    #    require => File[$sched_home_dir],
    #}
}
