class buildsystem::sshkeys {
    include ssh::auth
    include buildsystem::var::scheduler
    include buildsystem::var::iurt

    ssh::auth::key { $buildsystem::var::scheduler::login:
	home => $buildsystem::var::scheduler::homedir,
    }

    ssh::auth::key { $buildsystem::var::iurt::login:
	home => $buildsystem::var::iurt::homedir
    }
}
