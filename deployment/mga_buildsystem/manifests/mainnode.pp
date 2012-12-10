class mga_buildsystem::mainnode {
    include buildsystem::mainnode
    include buildsystem::sync20101
    include buildsystem::release
    include buildsystem::maintdb
    include buildsystem::binrepo
    include buildsystem::repoctl
    include buildsystem::pkgsubmit

    # Forward ports to arm1 and arm2 ssh, to access them from outside
    xinetd::port_forward {"forward_arm1":
	target_ip => 'arm1.mageia.org',
	target_port => '22',
	port => '4251',
	proto => 'tcp',
    }
    xinetd::port_forward {"forward_arm2":
	target_ip => 'arm2.mageia.org',
	target_port => '22',
	port => '4252',
	proto => 'tcp',
    }

    $rpmlint_packages = [ "rpmlint-mageia-policy", "rpmlint-mageia-mga2-policy"]
    package { $rpmlint_packages:
	ensure => installed,
    }
}
