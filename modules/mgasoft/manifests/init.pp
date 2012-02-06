class mgasoft(
    $anonsvn_soft = 'svn://svn.mageia.org/svn/soft',
    $pubinfodir = '/var/lib/mgasoft/infos',
    $pubmirrordir = '/distrib/mirror/software',
    $svn_soft_publish = 'file:///svn/soft_publish',
    $mgasoft_login = 'mgasoft'
) {
    group { $mgasoft_login:
	ensure => present,
    }
    user { $mgasoft_login:
	ensure => present,
	comment => "System user to publish software",
	managehome => true,
	home => "/var/lib/$mgasoft_login",
	gid => $mgasoft_login,
	require => Group[$mgasoft_login],
    }

    package { 'mgasoft-publish':
	ensure => installed,
    }

    file { '/etc/mgasoft.conf':
	ensure => present,
	owner => root,
	group => root,
	mode => 644,
	content => template('mgasoft/mgasoft.conf'),
    }

    subversion::snapshot { $pubinfodir:
	source => $svn_soft_publish,
	user => $mgasoft_login,
	refresh => '0',
	require => User[$mgasoft_login],
    }

    cron { "mgasoft-publish":
	command => '/usr/bin/mgasoft-publish',
	user => $mgasoft_login,
	minute => '*/5',
    }
}
