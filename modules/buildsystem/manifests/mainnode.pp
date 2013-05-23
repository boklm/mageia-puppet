class buildsystem::mainnode {
    include buildsystem::var::repository
    include buildsystem::iurt::user
    include buildsystem::scheduler
    include buildsystem::gatherer
    include buildsystem::mgarepo
    include buildsystem::signbot
    include buildsystem::youri_submit
    include buildsystem::sshkeys
    include buildsystem::distros

    sshkeys::set_client_key_pair { $buildsystem::var::scheduler::login:
	home => $buildsystem::var::scheduler::homedir,
	user => $buildsystem::var::scheduler::login,
    }
}
