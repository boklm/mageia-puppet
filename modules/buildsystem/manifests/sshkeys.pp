class buildsystem::sshkeys {
    include ssh::auth
    include buildsystem::scheduler::var
    include buildsystem::iurt::user

    ssh::auth::key { $buildsystem::scheduler::var::login:
	home => $buildsystem::scheduler::var::homedir,
    }

    ssh::auth::key { $buildsystem::iurt::user::login:
	home => $buildsystem::iurt::user::homedir
    }
}
