class websites::archives {
    include websites::base
    $vhost = "archives.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $svn_location = "svn://svn.$::domain/svn/web/archives/"

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
