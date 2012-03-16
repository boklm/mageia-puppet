define buildsystem::media_cfg() {
    include buildsystem::scheduler::var
    include buildsystem::repository
    
    $arch = $name
    $sched_login = $buildsystem::scheduler::var::login
    
    file { "$buildsystem::repository::root/distrib/cauldron/$arch/media/media_info/media.cfg":
        owner  => $buildsystem::base::sched_login,
        group  => $buildsystem::base::sched_login,
        source => "puppet:///modules/buildsystem/$arch/media.cfg",
    }
}
