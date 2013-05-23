class buildsystem::maintdb {
    include buildsystem::var::groups
    include buildsystem::var::webstatus
    include sudo
    $login = 'maintdb'
    $homedir = '/var/lib/maintdb'
    $dbdir = "$homedir/db"
    $binpath = '/usr/local/sbin/maintdb'
    $dump = "${buildsystem::var::webstatus::location}/data/maintdb.txt"
    $unmaintained = "${buildsystem::var::webstatus::location}/data/unmaintained.txt"

    user { $login:
        comment => 'Maintainers database',
        home    => $homedir,
    }

    file { [$homedir,$dbdir]:
        ensure  => directory,
        owner   => $login,
        group   => $login,
        mode    => '0711',
        require => User[$login],
    }

    file { $binpath:
        mode    => '0755',
        content => template('buildsystem/maintdb/maintdb.bin')
    }

    mga-common::local_script { 'wrapper.maintdb':
        content => template('buildsystem/maintdb/wrapper.maintdb')
    }

    sudo::sudoers_config { 'maintdb':
        content => template('buildsystem/maintdb/sudoers.maintdb')
    }

    file { [$dump,"$dump.new",
            $unmaintained,"$unmaintained.new"]:
        owner   => $login,
        require => File["${buildsystem::var::webstatus::location}/data"],
    }

    cron { 'update maintdb export':
        user    => $login,
        command => "$binpath root get > $dump.new; cp -f $dump.new $dump; grep ' nobody\$' $dump | sed 's/ nobody\$//' > $unmaintained.new; cp -f $unmaintained.new $unmaintained",
        minute  => '*/30',
        require => User[$login],
    }

    apache::vhost::base { "maintdb.$::domain":
        location => $dbdir,
        content  => template('buildsystem/maintdb/vhost_maintdb.conf'),
    }
}
