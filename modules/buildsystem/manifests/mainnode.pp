class buildsystem::mainnode {
    include buildsystem::var::repository
    include buildsystem::iurt::user
    include buildsystem::scheduler
    include buildsystem::gatherer
    include buildsystem::mgarepo
    include buildsystem::signbot
    include buildsystem::youri_submit
    include buildsystem::sshkeys

    ssh::auth::client { $buildsystem::var::scheduler::login: }

    apache::vhost::other_app { "repository.$::domain":
        vhost_file => 'buildsystem/vhost_repository.conf',
    }

    buildsystem::media_cfg { "cauldron i586":
	distro  => 'cauldron',
	arch    => 'i586',
    }
    buildsystem::media_cfg { "cauldron x86_64":
	distro  => 'cauldron',
	arch    => 'x86_64',
    }
}
