class postgresql {
    package { postgresql9.0-server:
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
        require => Package["postgresql9.0-server"],
        content => "",
        notify => [Service['postgreql']]
    }
    
    file { '/var/lib/pgsql/data/pg_hba.conf':
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 644,
        require => Package["postgresql9.0-server"],
        content => "",
        notify => [Service['postgresql']]
    }
}
