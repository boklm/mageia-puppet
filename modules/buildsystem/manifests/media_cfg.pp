define buildsystem::media_cfg($distro, $arch, $templatefile = 'buildsystem/media.cfg') {
    include buildsystem::scheduler::var
    include buildsystem::repository
    
    file { "${buildsystem::repository::dir}/distrib/${distro}/${arch}/media/media_info/media.cfg":
        owner  => $buildsystem::base::sched_login,
        group  => $buildsystem::base::sched_login,
	content => template($templatefile),
    }
}
