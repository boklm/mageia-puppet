class websites {
    class hugs inherits base {
        $vhostdir = "$webdatadir/hugs.$domain"
        $svn_location = "svn://svn.$domain/svn/web/hugs/public/"

    	apache::vhost_base { "hugs.$domain":
	        location => $vhostdir,
        }

        subversion::snapshot { "$vhostdir":
            source => $svn_location
        }

        package { php-exif: }
    }
}
