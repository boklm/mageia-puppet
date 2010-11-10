class mysql {

    package { 'mysql':
        ensure => installed
    }
    package { 'lighttpd-mod_mysql_vhost':
        ensure => installed
    }

    service { mysqld:
        ensure => running,
        subscribe => Package["mysql"],
    }
}
