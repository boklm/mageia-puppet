class buildsystem::buildnode {
    include buildsystem::base
    include buildsystem::iurt
    include buildsystem::var::scheduler
    include buildsystem::sshkeys

    # permit to scheduler to run iurt
    ssh::auth::server { $buildsystem::var::scheduler::login:
        user => $buildsystem::iurt::user::login,
    }
}
