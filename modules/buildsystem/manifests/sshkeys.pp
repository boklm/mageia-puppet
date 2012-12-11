class buildsystem::sshkeys {
    include ssh::auth
    include buildsystem::var::scheduler
    include buildsystem::iurt::user

    ssh::auth::key { $buildsystem::var::scheduler::login:
	home => $buildsystem::var::scheduler::homedir,
    }

    ssh::auth::key { $buildsystem::iurt::user::login:
	home => $buildsystem::iurt::user::homedir
    }
}
