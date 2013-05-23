class buildsystem::repository {
    file { $buildsystem::var::repository::bootstrap_root:
	ensure => directory,
    }
}
