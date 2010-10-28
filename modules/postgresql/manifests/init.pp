class postgresql {
    package { 'postgresql9.0-server':
        ensure => installed
    }

    service { postgresql:
        restart => "/etc/rc.d/init.d/postgresql reload"
    }

    file { '/var/lib/pgsql/data/postgresql.conf':
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 644,
        content => template("postgresql/postgresql.conf"),
        require => Package["postgresql9.0-server"],
        notify => [Service['postgreql']]
    }
    
    file { '/var/lib/pgsql/data/pg_hba.conf':
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 644,
        content => template("postgresql/pg_hba.conf"),
        require => Package["postgresql9.0-server"],
        notify => [Service['postgresql']]
    }
}
