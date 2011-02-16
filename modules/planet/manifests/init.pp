class planet {

    user { "planet":
	groups => apache,
	comment => "User running cronjob and deploying planet software",
	ensure => present,
	managehome => true,
	home => "/var/lib/planet",
    }

    $planet_location = "/var/www/html/planet.$domain"
    $planet_domain = "planet.$domain"
	
    include apache::mod_php
    include apache::mod_deflate
    apache::vhost_base { "$planet_domain":
	location => $planet_location,
        content => template('planet/planet_vhosts.conf')
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
