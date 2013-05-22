class buildsystem::buildnode {
    include buildsystem::iurt
    include buildsystem::var::scheduler
    include buildsystem::var::iurt
    include buildsystem::sshkeys

    # permit to scheduler to run iurt
    ssh::auth::server { $buildsystem::var::scheduler::login:
        user => $buildsystem::var::iurt::login,
    }
}
