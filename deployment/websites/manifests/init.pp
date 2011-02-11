class websites {
    class base {
       # FIXME :
       # We should be able to define this path on each host.
       # Maybe using Facter ?
       $webdatadir = '/srv/web1-dd0/www'

       file { "$webdatadir":
          ensure => directory,
	  mode => 755,
       }
    }

    # should expire on June 2011
    class donate {
        apache::vhost_other_app { "donate.$domain":
            vhost_file => "websites/vhost_donate.conf",
        }
    }

    # vhost to host static files used by web sites
    class static inherits base {
        $vhostdir = "$webdatadir/static.$domain"
	$svn_location = "svn://svn.$domain/svn/web/www/trunk/g/"
    	apache::vhost_other_app { "static.$domain":
	    vhost_file => 'websites/vhost_static.conf',
	}

	file { $vhostdir:
	    ensure => directory,
	    mode => 655,
	}

	subversion::snapshot { "$vhostdir/g":
	    source => $svn_location
	}
    }

    class svn {
        apache::vhost_redirect { "svn.$domain":
            url => "http://svnweb.$domain/",
        }
    }
}
