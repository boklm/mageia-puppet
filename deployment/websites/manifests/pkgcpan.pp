class websites::pkgcpan {
    include websites::base
    $vhost = "pkgcpan.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"

    apache::vhost_base { $vhost:
        location => $vhostdir,
        options  => [ 'Indexes' ],
    }

    file { $vhostdir:
        ensure => directory,
    }

    package { 'perl-Module-Packaged-Generator': }

    # FIXME do not run as root ( apache or nobody should enough )
    cron { 'update cpanpkg':
        hour    => 23,
        require => Package['perl-Module-Packaged-Generator'],
        command => "pkgcpan -q -f $vhostdir/cpan_Mageia.db -d Mageia",
    }
}
