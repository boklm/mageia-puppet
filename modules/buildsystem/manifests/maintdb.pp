class buildsystem::maintdb {
    include buildsystem::var::maintdb
    include buildsystem::var::groups
    include buildsystem::var::webstatus
    include sudo

    user { $buildsystem::var::maintdb::login:
        comment => 'Maintainers database',
        home    => $buildsystem::var::maintdb::homedir,
    }

    file { [$buildsystem::var::maintdb::homedir,$buildsystem::var::maintdb::dbdir]:
        ensure  => directory,
        owner   => $buildsystem::var::maintdb::login,
        group   => $buildsystem::var::maintdb::login,
        mode    => '0711',
        require => User[$buildsystem::var::maintdb::login],
    }

    file { $buildsystem::var::maintdb::binpath:
        mode    => '0755',
        content => template('buildsystem/maintdb/maintdb.bin')
    }

    mga-common::local_script { 'wrapper.maintdb':
        content => template('buildsystem/maintdb/wrapper.maintdb')
    }

    sudo::sudoers_config { 'maintdb':
        content => template('buildsystem/maintdb/sudoers.maintdb')
    }

    file { [$buildsystem::var::maintdb::dump,
            "${buildsystem::var::maintdb::dump}.new",
            $buildsystem::var::maintdb::unmaintained,
	    "${buildsystem::var::maintdb::unmaintained}.new"]:
        owner   => $buildsystem::var::maintdb::login,
        require => File["${buildsystem::var::webstatus::location}/data"],
    }

    cron { 'update maintdb export':
        user    => $buildsystem::var::maintdb::login,
        command => "${buildsystem::var::maintdb::binpath} root get > ${buildsystem::var::maintdb::dump}.new; cp -f ${buildsystem::var::maintdb::dump}.new ${buildsystem::var::maintdb::dump}; grep ' nobody\$' ${buildsystem::var::maintdb::dump} | sed 's/ nobody\$//' > ${buildsystem::var::maintdb::unmaintained}.new; cp -f ${buildsystem::var::maintdb::unmaintained}.new ${buildsystem::var::maintdb::unmaintained}",
        minute  => '*/30',
        require => User[$buildsystem::var::maintdb::login],
    }

    apache::vhost::base { $buildsystem::var::maintdb::hostname:
        location => $buildsystem::var::maintdb::dbdir,
        content  => template('buildsystem/maintdb/vhost_maintdb.conf'),
    }
}
