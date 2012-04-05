class buildsystem::repoctl {
	include buildsystem::config

	$distroreleases = [$buildsystem::config::dev_distros,
	                   $buildsystem::config::stable_distros]
	$distrosections = $buildsystem::config::distrosections
	$sectionsrepos = $buildsystem::config::sectionsrepos
	$arches = $buildsystem::config::architectures

	package{'repoctl':
	    ensure => installed,
	}

	file {'/etc/repoctl.conf':
	    ensure => present,
	    mode => 644,
	    owner => root,
	    group => root,
	    content => template('buildsystem/repoctl.conf'),
	    require => Package['repoctl'],
	}
}
