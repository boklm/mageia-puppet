class buildsystem::buildnode {
    include buildsystem::iurt
    include buildsystem::var::scheduler
    include buildsystem::var::iurt
    include buildsystem::sshkeys

    sshkeys::set_authorized_keys { 'iurt-allow-scheduler':
        keyname => $buildsystem::var::scheduler::login,
        home => $buildsystem::var::iurt::homedir,
        user => $buildsystem::var::iurt::login,
    }
}
