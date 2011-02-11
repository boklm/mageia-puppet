class planet {
    user { "planet":
	groups => apache,
	comment => "User running cronjob and deploying planet software",
	ensure => present,
	managehome => true,
    }

    include apache::mod_php
    include apache::mod_deflate
    apache::vhost_other_app { "planet.$domain":
        vhost_file => "planet/02_planet_vhosts.conf",
    }

    file { "/var/www/html/planet.$domain":
	ensure => directory,
	owner => planet,
	group => planet,
	mode => 644,
    }

    package { ['php-iconv']:
        ensure => installed
    }
}
