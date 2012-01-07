class buildsystem {
    class maintdb {
    	include sudo
        $login = "maintdb"
        $homedir = "/var/lib/maintdb"
        $dbdir = "$maintdb_homedir/db"
        $binpath = "/usr/local/sbin/maintdb"
        $wrappath = "/usr/local/bin/wrapper.maintdb"
        $dump = "/var/www/bs/data/maintdb.txt"
        $maintdb_unmaintained = "/var/www/bs/data/unmaintained.txt"

        user {"$login":
            ensure => present,
            comment => "Maintainers database",
            managehome => true,
            shell => "/bin/bash",
            home => "$homedir",
        }

        file { ["$homedir","$dbdir"]:
            ensure => directory,
            owner => "$login",
            group => "$login",
            mode => 711,
            require => User["$login"],
        }

        file { "$binpath":
            mode => 755,
            content => template("buildsystem/maintdb")
        }

        file { "$wrappath":
            mode => 755,
            content => template("buildsystem/wrapper.maintdb")
        }

        sudo::sudoers_config { "maintdb":
            content => template("buildsystem/sudoers.maintdb")
        }

        file { ["$dump","$dump.new",
                "$unmaintained","$unmaintained.new"]:
            ensure => present,
            owner => $login,
            mode => 644,
            require => File["/var/www/bs/data"],
        }

        cron { "update maintdb export":
            user => $login,
            command => "$binpath root get > $dump.new; mv -f $dump.new $dump; grep ' nobody\$' $dump | sed 's/ nobody\$//' > $unmaintained.new; mv -f $unmaintained.new $unmaintained",
            minute => "*/30",
            require => User[$login],
        }

        apache::vhost_base { "maintdb.$domain":
            location => $dbdir,
            content => template("buildsystem/vhost_maintdb.conf"),
        }
    }
}

