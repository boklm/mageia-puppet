class websites::www {
    include websites::base
    $vhost = "www.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $svn_location = "svn://svn.$::domain/svn/web/www/trunk"

    include apache::var
    include apache::mod::php

    # for mailman reverse proxy, on ssl
    include apache::mod::proxy
    include apache::mod::ssl

    subversion::snapshot { $vhostdir:
        source => $svn_location,
    }

    file { "$vhostdir/var/tmp/cache":
        ensure => directory,
        group  => $apache::var::apache_group,
        mode   => '0660',
    }

    apache::vhost::base { $vhost:
        content  => template('websites/vhost_www.conf',
                             'websites/vhost_www_rewrite.conf'),
        location => $vhostdir,
        options  => ['FollowSymLinks'],
    }

    apache::vhost::base { "ssl_$vhost":
        use_ssl  => true,
        vhost    => $vhost,
        content  => template('websites/vhost_www.conf',
                             'websites/vhost_www_rewrite.conf'),
        location => $vhostdir,
        options  => ['FollowSymLinks'],
    }

    apache::vhost_redirect { $::domain:
        url => "http://www.$::domain/",
    }

    apache::vhost_redirect { "ssl_$::domain":
        use_ssl => true,
        vhost   => $::domain,
        url     => "https://www.$::domain/",
    }

    package { ['php-mbstring', 'php-mcrypt', 'php-gettext', 'php-geoip']: }
}
