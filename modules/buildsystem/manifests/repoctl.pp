class buildsystem::repoctl {
    include buildsystem::var::distros
    include buildsystem::var::repository

    package{ 'repoctl': }

    file { '/etc/repoctl.conf':
	content => template('buildsystem/repoctl.conf'),
	require => Package['repoctl'],
    }
}
