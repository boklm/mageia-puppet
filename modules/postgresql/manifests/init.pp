class postgresql {
    package { 'postgresql9.0-server':
        ensure => installed
    }

    service { postgresql:
        ensure => running,
        subscribe => Package[postgresql9.0-server"],
        restart => "/etc/rc.d/init.d/postgresql reload"
    }

    file { '/etc/pam.d/postgresql':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 644,
        content => template("postgresql/pam"),
    }

    file { '/var/lib/pgsql/data/postgresql.conf':
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        content => template("postgresql/postgresql.conf"),
        require => Package["postgresql9.0-server"],
        notify => [Service['postgresql']]
    }
    
    file { '/var/lib/pgsql/data/pg_hba.conf':
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        content => template("postgresql/pg_hba.conf"),
        require => Package["postgresql9.0-server"],
        notify => [Service['postgresql']]
    }
}
