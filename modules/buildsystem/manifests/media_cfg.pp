define buildsystem::media_cfg() {
    $arch = $name
    file { "$buildsystem::base::repository_root/distrib/cauldron/$arch/media/media_info/media.cfg":
        owner  => $buildsystem::base::sched_login,
        group  => $buildsystem::base::sched_login,
        source => "puppet:///modules/buildsystem/$arch/media.cfg",
    }
}


