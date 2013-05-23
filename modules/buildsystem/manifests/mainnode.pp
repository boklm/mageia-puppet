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

    ssh::auth::client { $buildsystem::var::scheduler::login: }
}
