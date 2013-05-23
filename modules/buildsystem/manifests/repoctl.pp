class buildsystem::repoctl {
    include buildsystem::config

    $distroreleases = [$buildsystem::config::dev_distros,
    $buildsystem::config::stable_distros]
    $distrosections = $buildsystem::config::distrosections
    $sectionsrepos = $buildsystem::config::sectionsrepos
    $arches = $buildsystem::config::architectures

    package{ 'repoctl': }

    file { '/etc/repoctl.conf':
	content => template('buildsystem/repoctl.conf'),
	require => Package['repoctl'],
    }
}
