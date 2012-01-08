class websites {
    class releases inherits base {
        $vhostdir = "$webdatadir/releases.$domain"
        $svn_location = "svn://svn.$domain/svn/web/releases/"

        apache::vhost_base { "releases.$domain":
            location => $vhostdir,
            options => [ "FollowSymLinks" ],
	    }

    	apache::vhost_base { "ssl_releases.$domain":
            vhost => "releases.$domain",
            use_ssl => true,
            location => $vhostdir,
            options => [ "FollowSymLinks" ],
        }

        subversion::snapshot { "$vhostdir":
            source => $svn_location,
        }
    }
}
