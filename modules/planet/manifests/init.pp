#TODO: 
# - add the creation of the user 'planet' in puppet
# - add the user 'planet' to the 'apache' group (usermod -a -G apache blog)
class blog {
    include apache::mod_php

    apache::vhost_other_app { "planet.$domain":
        vhost_file => "planet/02_planet_vhosts.conf",
    }

    file { "/var/www/html/planet.mageia.org":
	ensure => directory,
	owner => apache,
	group => blog,
	mode => 644,
    }
}
