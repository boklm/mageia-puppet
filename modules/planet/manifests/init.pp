class planet {
    user { "planet":
	groups => apache,
	comment => "This user is used for planet",
	ensure => present,
	managehome => true,
    }

    include apache::mod_php
    apache::vhost_other_app { "planet.$domain":
        vhost_file => "planet/02_planet_vhosts.conf",
    }

    file { "/var/www/html/planet.$domain":
	ensure => directory,
	owner => planet,
	group => planet,
	mode => 644,
    }
}
