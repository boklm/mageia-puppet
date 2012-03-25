class websites::pkgcpan {
    include websites::base
    $vhost = "pkgcpan.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
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

    package { 'perl-Module-Packaged-Generator': }

    cron { 'update cpanpkg':
        hour    => 23,
        require => Package['perl-Module-Packaged-Generator'],
        command => "pkgcpan -q -f $vhostdir/cpan_Mageia.db -d Mageia",
        user    => $login,
    }

    file { "$vhostdir/cpan_Mageia.db":
        owner => $login,
        group => $login,
    }
}
