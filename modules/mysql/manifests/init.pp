class mysql {

    package { 'mysql':
        ensure => installed
    }
    package { 'mod_mysql':
        ensure => installed
    }

    service { mysqld:
        ensure => running,
        subscribe => Package["mysql"],
    }
}
