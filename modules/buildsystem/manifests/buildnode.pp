class buildsystem::buildnode {
    include buildsystem::base
    include buildsystem::iurt
    include buildsystem::scheduler::user

    ssh::auth::key { $buildsystem::scheduler::var::login:
        home => $buildsystem::scheduler::var::homedir,

    }
    # permit to scheduler to run iurt
    ssh::auth::server { $buildsystem::scheduler::var::login:
        user => $buildsystem::iurt::user::login,
    }
}
