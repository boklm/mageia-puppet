class websites {
    class static inherits base {
        $vhostdir = "$webdatadir/static.$domain"

        apache::vhost_other_app { "static.$domain":
            vhost_file => 'websites/vhost_static.conf',
        }

        file { $vhostdir:
            ensure => directory,
        }

        subversion::snapshot { "$vhostdir/g":
            source => "svn://svn.$domain/svn/web/www/trunk/g/",
        }
    }
}
