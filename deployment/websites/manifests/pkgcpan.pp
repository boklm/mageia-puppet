class websites::pkgcpan {
    include websites::base
    $vhost = "pkgcpan.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $pkgcpan_login = 'pkgcpan'
    $pkgcpan_homedir = "/var/lib/$pkgcpan_login"

    user { $pkgcpan_login:
	managehome => true,
	home => $pkgcpan_homedir,
    }

    apache::vhost_base { $vhost:
        location => $vhostdir,
        options  => [ 'Indexes' ],
    }

    file { $vhostdir:
        ensure => directory,
	owner => $pkgcpan_login,
	group => $pkgcpan_login,
    }

    package { 'perl-Module-Packaged-Generator': }

    cron { 'update cpanpkg':
        hour    => 23,
        require => Package['perl-Module-Packaged-Generator'],
        command => "pkgcpan -q -f $vhostdir/cpan_Mageia.db -d Mageia",
	user => $pkgcpan_login,
    }
}
