class buildsystem {
    class maintdb inherits base {
    	include sudo
        $maintdb_login = "maintdb"
        $maintdb_homedir = "/var/lib/maintdb"
        $maintdb_dbdir = "$maintdb_homedir/db"
        $maintdb_binpath = "/usr/local/sbin/maintdb"
        $maintdb_wrappath = "/usr/local/bin/wrapper.maintdb"
        $maintdb_dump = "/var/www/bs/data/maintdb.txt"
        $maintdb_unmaintained = "/var/www/bs/data/unmaintained.txt"

        user {"$maintdb_login":
            ensure => present,
            comment => "Maintainers database",
            managehome => true,
            shell => "/bin/bash",
            home => "$maintdb_homedir",
        }

        file { "$maintdb_homedir":
            ensure => directory,
            owner => "$maintdb_login",
            group => "$maintdb_login",
            mode => 711,
            require => User["$maintdb_login"],
        }

        file { "$maintdb_dbdir":
            ensure => directory,
            owner => "$maintdb_login",
            group => "$maintdb_login",
            mode => 711,
            require => User["$maintdb_login"],
        }

        file { "$maintdb_binpath":
            mode => 755,
            content => template("buildsystem/maintdb")
        }

        file { "$maintdb_wrappath":
            mode => 755,
            content => template("buildsystem/wrapper.maintdb")
        }

        sudo::sudoers_config { "maintdb":
            content => template("buildsystem/sudoers.maintdb")
        }

        file { ["$maintdb_dump","$maintdb_dump.new",
                "$maintdb_unmaintained","$maintdb_unmaintained.new"]:
            ensure => present,
            owner => $maintdb_login,
            mode => 644,
            require => File["/var/www/bs/data"],
        }

        cron { "update maintdb export":
            user => $maintdb_login,
            command => "$maintdb_binpath root get > $maintdb_dump.new; mv -f $maintdb_dump.new $maintdb_dump; grep ' nobody\$' $maintdb_dump | sed 's/ nobody\$//' > $maintdb_unmaintained.new; mv -f $maintdb_unmaintained.new $maintdb_unmaintained",
            minute => "*/30",
            require => User[$maintdb_login],
        }

        apache::vhost_base { "maintdb.$domain":
            location => $maintdb_dbdir,
            content => template("buildsystem/vhost_maintdb.conf"),
        }
    }
}

