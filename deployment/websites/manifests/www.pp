class websites::www {
    include websites::base
    $vhost = "www.$::domain"
    $vhostdir = "$websites::base::webdatadir/$vhost"
    $svn_location = "svn://svn.$::domain/svn/web/www/trunk"

    include apache::mod_php
    include apache::mod_geoip

    # for mailman reverse proxy, on ssl
    include apache::mod_proxy
    include apache::mod_ssl

    subversion::snapshot { $vhostdir:
        source => $svn_location,
    }

    file { "$vhostdir/var/tmp/cache":
        ensure => directory,
        group  => $apache::base::apache_group,
        mode   => '0660',
    }

    $mailman_content = template('websites/vhost_www.conf',
                                'websites/vhost_proxy_mailman.conf')
    apache::vhost_base { $vhost:
        content  => $mailman_content,
        location => $vhostdir,
        options  => ['FollowSymLinks'],
    }

    apache::vhost_base { "ssl_$vhost":
        use_ssl  => true,
        vhost    => $vhost,
        content  => $mailman_content,
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
