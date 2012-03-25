class websites::hugs {
    include websites::base

    $vhostdir = "$websites::base::webdatadir/hugs.$::domain"
    $svn_location = "svn://svn.$::domain/svn/web/hugs/public/"

    apache::vhost::base { "hugs.$::domain":
        location => $vhostdir,
    }

    subversion::snapshot { $vhostdir:
        source => $svn_location
    }

    package { 'php-exif': }
}
