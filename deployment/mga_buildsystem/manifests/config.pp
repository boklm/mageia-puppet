class mga_buildsystem::config {
    class { 'buildsystem::var::signbot':
	keyid => '80420F66',
    }

    include buildsystem::var::scheduler
    include buildsystem::var::repository
    class { 'buildsystem::var::youri':
        packages_archivedir => "${buildsystem::var::scheduler::homedir}/old",
    }
}
