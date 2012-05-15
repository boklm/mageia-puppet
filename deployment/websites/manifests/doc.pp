class websites::doc {
    include websites::base
    $vhost = "doc.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $svn_location = "svn://svn.$::domain/svn/web/doc/"

    apache::vhost::base { $vhost:
        location => $vhostdir,
    }

    apache::vhost::base { "ssl_$vhost":
        vhost    => $vhost,
        use_ssl  => true,
        location => $vhostdir,
    }

    subversion::snapshot { $vhostdir:
        source => $svn_location,
    }
}
