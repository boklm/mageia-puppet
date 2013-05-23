class buildsystem::repository {
    include buildsystem::var::repository
    file { [ $buildsystem::var::repository::bootstrap_root,
             $buildsystem::var::repository::bootstrap_reporoot ] :
	ensure => directory,
    }

    apache::vhost::other_app { $buildsystem::var::repository::hostname:
	vhost_file => 'buildsystem/vhost_repository.conf',
    }
}
