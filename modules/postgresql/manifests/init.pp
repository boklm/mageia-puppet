class postgresql {
    
    $pgsql_data = "/var/lib/pgsql/data/"

    package { 'postgresql9.0-server':
        alias => "postgresql-server",
        ensure => installed
    }

    service { postgresql:
        ensure => running,
        subscribe => Package["postgresql-server"],
        hasstatus => true,
    }

    exec { "service postgresql reload":
        refreshonly => true,
        subscribe => [ File["postgresql.conf"], 
                       File["pg_ident.conf"],
                       File["pg_hba.conf"] ]
    }

    file { '/etc/pam.d/postgresql':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 644,
        content => template("postgresql/pam"),
    }

    file { "postgresql.conf":
        path => "$pgsql_data/postgresql.conf",
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        content => template("postgresql/postgresql.conf"),
        require => Package["postgresql-server"],
    }
    
    file { 'pg_hba.conf':
        path => "$pgsql_data/pg_hba.conf",
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        content => template("postgresql/pg_hba.conf"),
        require => Package["postgresql-server"],
    }

    file { 'pg_ident.conf':
        path => "$pgsql_data/pg_ident.conf",
        ensure => present,
        owner => postgres,
        group => postgres,
        mode => 600,
        content => template("postgresql/pg_ident.conf"),
        require => Package["postgresql-server"],
    }
}
