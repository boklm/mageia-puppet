class buildsystem::buildnode {
    include buildsystem::base
    include buildsystem::iurt
    # permit to scheduler to run iurt
    ssh::auth::server { $buildsystem::scheduler::var::login:
                        user => $buildsystem::iurt::user::login,
    }
}
