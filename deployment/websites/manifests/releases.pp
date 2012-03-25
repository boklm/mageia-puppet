class websites::releases {
    include websites::base
    $vhost = "releases.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $svn_location = "svn://svn.$::domain/svn/web/releases/"

    apache::vhost::base { $vhost:
        location => $vhostdir,
        options  => [ 'FollowSymLinks' ],
    }

    apache::vhost::base { "ssl_$vhost":
        vhost    => $vhost,
        use_ssl  => true,
        location => $vhostdir,
        options  => [ 'FollowSymLinks' ],
    }

    subversion::snapshot { $vhostdir:
        source => $svn_location,
    }
}
