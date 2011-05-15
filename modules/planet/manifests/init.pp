class planet {

    user { "planet":
	groups => apache,
	comment => "Planet Mageia",
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

    file { "/var/www/vhosts/planet.$domain":
	ensure => directory,
	owner => planet,
	group => apache,
	mode => 644,
    }

    file { "index":
        path => "$planet_location/index.php",
        ensure => present,
        owner => planet,
        group => apache,
        mode => 755,
        content => template("planet/index.php")
    }

    package { ['php-iconv']:
        ensure => installed
    }    

    class files_backup inherits base {
        file { "/var/lib/planet/backup":
                ensure => directory,
                owner => root,
                group => root,
                mode => 644,
        }

        file { "backup_planet-files":
            path => "/usr/local/bin/backup_planet-files.sh",
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("blog/backup_planet-files.sh")
        }

        cron { "Backup files (planet)":
            user => root,
            hour => '23',
            minute => '42',
            command => "/usr/local/bin/backup_planet-files.sh",
            require => [File["backup_planet-files"]],
        }
    }
}
