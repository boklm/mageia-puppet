class mysql {

    package { 'mysql':
        ensure => installed
    }
    package { 'php-mysql':
        ensure => installed
    }

    service { mysqld:
        ensure => running,
        subscribe => Package["mysql"],
    }
}
