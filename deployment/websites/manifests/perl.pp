class websites::perl {
    include websites::base
    $vhost = "perl.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $statsdir = "${vhostdir}/stats"
    $login = 'pkgcpan'
    $homedir = "/var/lib/$login"

    user { $login:
        managehome => true,
        home       => $homedir,
    }

    apache::vhost::base { $vhost:
        location => $vhostdir,
        options  => [ 'Indexes' ],
    }

    file { $vhostdir:
        ensure => directory,
        owner  => $login,
        group  => $login,
    }

    package { ['perl-Module-Packaged-Generator', 'magpie']: }

    cron { 'update cpanpkg':
        hour    => 23,
	minute	=> 0,
        require => Package['perl-Module-Packaged-Generator'],
        command => "pkgcpan -q -f $vhostdir/cpan_Mageia.db -d Mageia",
        user    => $login,
    }

    file { "$vhostdir/cpan_Mageia.db":
        owner => $login,
        group => $login,
    }

    file { $statsdir:
	ensure => directory,
	owner => $login,
	group => $login,
    }

    # http://www.mageia.org/pipermail/mageia-sysadm/2012-March/004337.html
    cron { 'update pkgcpan stats':
	hour	=> 23,
	minute	=> 30,
	require => [ Package['magpie'], File[$statsdir] ],
	command => "magpie webstatic -qq -d $statsdir",
	user	=> $login,
    }
}
