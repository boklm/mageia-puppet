class mga_buildsystem::mainnode {
    include mga_buildsystem::config
    include buildsystem::mainnode
    include buildsystem::release
    include buildsystem::maintdb
    include buildsystem::binrepo
    include buildsystem::repoctl
    include buildsystem::webstatus

    $rpmlint_packages = [ "rpmlint-mageia-policy", "rpmlint-mageia-mga2-policy"]
    package { $rpmlint_packages:
	ensure => installed,
    }
}
