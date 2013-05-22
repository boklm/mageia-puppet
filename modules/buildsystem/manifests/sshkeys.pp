class buildsystem::sshkeys {
    include ssh::auth
    include buildsystem::var::scheduler

    ssh::auth::key { $buildsystem::var::scheduler::login:
	home => $buildsystem::var::scheduler::homedir,
    }
}
