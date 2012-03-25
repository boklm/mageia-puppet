class planet {

    user { "planet":
        groups => apache,
        comment => "Planet Mageia",
        home => "/var/lib/planet",
    }

    $location = "/var/www/vhosts/planet.$domain"
    $vhost = "planet.$domain"
	
    include apache::mod::php
    include apache::mod::deflate

    apache::vhost::base { "$vhost":
        location => $location,
        content => template('planet/planet_vhosts.conf')
    }

    local_script { "deploy_new-planet.sh":
        content => template("planet/deploy_new-planet.sh")
    }

    file { "$location":
        ensure => directory,
        owner => planet,
        group => apache,
    }

    file { "$location/index.php":
        owner => planet,
        group => apache,
        mode => 755,
        content => template("planet/index.php")
    }

    package { ['php-iconv']: }    

    class files_backup inherits base {
        file { "/var/lib/planet/backup":
                ensure => directory,
        }

        local_script { "backup_planet-files.sh":
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
