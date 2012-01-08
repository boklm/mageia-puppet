class websites {
    class www inherits base {
        $vhost = "www.$domain"
        $vhostdir = "$webdatadir/www.$domain"
        $svn_location = "svn://svn.$domain/svn/web/www/trunk"

        include apache::mod_php
        include apache::mod_geoip

        subversion::snapshot { $vhostdir:
            source => $svn_location,
        }

        file { "$vhostdir/var/tmp/cache":
            ensure => directory,
            owner => root,
            group => $apache::base::apache_group,
            mode => 0660,
        }

        apache::vhost_base { "$vhost":
            content => template('websites/vhost_www.conf'),
            location => $vhostdir,
            options => ['FollowSymLinks'],
        }

        apache::vhost_base { "ssl_$vhost":
            use_ssl => true,
            vhost => $vhost,
            content => template('websites/vhost_www.conf'),
            location => $vhostdir,
            options => ['FollowSymLinks'],
        }

        apache::vhost_redirect { $domain:
            url => 'http://www.mageia.org/',
        }

        apache::vhost_redirect { "ssl_$domain":
            use_ssl => true,
            vhost => $domain,
            url => 'https://www.mageia.org/',
        }

        package { ['php-mbstring', 'php-mcrypt', 'php-gettext']: }
    }
}
