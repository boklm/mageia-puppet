class buildsystem::buildnode {
    include buildsystem::base
    include buildsystem::iurt
    include buildsystem::scheduler::var
    include buildsystem::sshkeys

    # permit to scheduler to run iurt
    ssh::auth::server { $buildsystem::scheduler::var::login:
        user => $buildsystem::iurt::user::login,
    }
}
