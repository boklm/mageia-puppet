class mgasoft(
    $anonsvn_soft = 'svn://svn.mageia.org/svn/soft',
    $pubinfodir = '/var/lib/mgasoft/infos',
    $pubmirrordir = '/distrib/mirror/software',
    $svn_soft_publish = 'file:///svn/soft_publish',
    $mgasoft_login = 'mgasoft'
) {
    group { $mgasoft_login: }

    user { $mgasoft_login:
        comment    => 'System user to publish software',
        managehome => true,
        home       => "/var/lib/$mgasoft_login",
        gid        => $mgasoft_login,
        require    => Group[$mgasoft_login],
    }

    package { 'mgasoft-publish': }

    file { '/etc/mgasoft.conf':
        content => template('mgasoft/mgasoft.conf'),
    }

    subversion::snapshot { $pubinfodir:
        source  => $svn_soft_publish,
        user    => $mgasoft_login,
        refresh => '0',
        require => User[$mgasoft_login],
    }

    cron { "mgasoft-publish":
        command => '/usr/bin/mgasoft-publish',
        user    => $mgasoft_login,
        minute  => '*/5',
        require => User[$mgasoft_login],
    }
}
