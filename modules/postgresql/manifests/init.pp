class postgresql {
    class server { 
        $pgsql_data = "/var/lib/pgsql/data/"
        $pg_version = '9.0'
    
        # missing requires is corrected in cooker, 
        # should be removed
        # once the fix is in a stable release 
        package { "postgresql$pg_version-plpgsql":
            alias => "postgresql-plpgsql",
            ensure => installed,
        }
    
        package { "postgresql$pg_version-server":
            alias => "postgresql-server",
            ensure => installed,
            require => Package['postgresql-plpgsql'],
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
   
        openssl::self_signed_splitted_cert { "pgsql.$domain":
            filename => "server",
            directory => $pgsql_data,
            owner => "postgres",
            group => "postgres",
            require => Package['postgresql-server']
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

        Postgresql::User <<| |>>
        Postgresql::Database <<| |>>
    }


    # TODO convert it to a regular type ( so we can later change user and so on )
    define database($description="", $user="postgres") {
        exec { "createdb -O $user -U postgres $name '$description'":
            user => root,
            unless => "psql -A -t -U postgres -l | grep '^$name|'",
        }
    }

    define user($password) {
        $sql = "CREATE ROLE $name ENCRYPTED PASSWORD '$password' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

        exec { "psql -U postgres -c \"$sql\" ":
            user => root,
            unless => "psql -A -t -U postgres -c '\du $name' | grep '$name'",
        }
    }
}
