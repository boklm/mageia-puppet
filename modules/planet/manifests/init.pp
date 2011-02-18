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

    file { "deploy_new-planet":
        path => "/usr/local/bin/deploy_new-planet.sh",
        ensure => present,
        owner => root,
        group => root,
        mode => 755,
        content => template("planet/deploy_new-planet.sh")
    }

    file { "/var/www/html/planet.$domain":
	ensure => directory,
	owner => planet,
	group => apache,
	mode => 644,
    }

    file { "index":
        path => "$planet_location/index.php",
        ensure => present
        owner => planet,
        group => apache,
        mode => 755,
        content => template("planet/index.php")
    }

    package { ['php-iconv']:
        ensure => installed
    }
}
