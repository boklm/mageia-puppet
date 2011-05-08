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

    class hugs inherits base {
        $vhostdir = "$webdatadir/hugs.$domain"
	$svn_location = "svn://svn.$domain/svn/web/hugs/public/"
    	apache::vhost_base { "hugs.$domain":
	    location => $vhostdir,
	}

	subversion::snapshot { "$vhostdir":
	    source => $svn_location
	}
    }

    class releases inherits base {
        $vhostdir = "$webdatadir/releases.$domain"
	$svn_location = "svn://svn.$domain/svn/web/releases/"
    	apache::vhost_base { "releases.$domain":
	    location => $vhostdir,
	    options => [ "FollowSymLinks" ]
	}

	subversion::snapshot { "$vhostdir":
	    source => $svn_location
	}
    }

    class svn {
        apache::vhost_redirect { "svn.$domain":
            url => "http://svnweb.$domain/",
        }
    }

    class forum_proxy {

        $web_domain = "forums.$domain"
        host { "$web_domain":
            ip => '192.168.122.131',
            ensure => 'present',
        }

        apache::vhost_reverse_proxy { "$web_domain":
            url => "http://$web_domain/",
        } 

        apache::vhost_reverse_proxy { "ssl_$web_domain":
            vhost => $web_domain,
            use_ssl => true,
            url => "http://$web_domain/",
        } 
    }
}
