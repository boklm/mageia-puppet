class buildsystem::sshkeys {
    include buildsystem::var::scheduler

    sshkeys::create_key { $buildsystem::var::scheduler::login: }
}
