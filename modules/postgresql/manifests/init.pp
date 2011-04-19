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
        
        $db = list_exported_ressources('Postgresql::Db_and_user')

        $forum_lang = list_exported_ressources('Phpbb::Locale_db')
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

    define tagged() {
        # TODO add a system of tag so we can declare database on more than one
        # server 
        Postgresql::User <<| tag == $name |>>
        Postgresql::Database <<| tag == $name |>>
        Postgresql::Db_and_user <<| tag == $name |>>
    }


    define remote_db_and_user($description = "",
                              $tag = "default",
                              $password ) {

        @@postgresql::db_and_user { $name:
                                    tag => $tag,
                                    description => $description,
                                    password => $password
        }
    }

    define remote_database($description = "", 
                           $user = "postgresql", 
                           $tag = "default")
    {
        @@postgresql::database { $name:
            description => $description,
            user => $user,
            tag => $tag,
            require => Postgresql::User[$user]
        }
    }

    define remote_user($password, 
                       $tag = "default")
    {
        @@postgresql::user { $name:
            tag => $tag,
            password => $password,
        }
    }

    define db_and_user($description = "",
                       $password ) {

        database { $name:
                   description => $description,
                   user => $name,
        }

        user { $name:
               password => $password
        }
    }

    # TODO convert it to a regular type ( so we can later change user and so on )
    define database($description="", $user="postgres") {
        exec { "createdb -O $user -U postgres $name '$description'":
            user => root,
            unless => "psql -A -t -U postgres -l | grep '^$name|'",
            require => Service['postgresql'],
        }
    }
    
    # TODO convert to a regular type, so we can later change password without erasing the 
    # current user
    define user($password) {
        $sql = "CREATE ROLE $name ENCRYPTED PASSWORD '\$pass' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"

        exec { "psql -U postgres -c \"$sql\" ":
            user => root,
            environment => "pass=$password", 
            unless => "psql -A -t -U postgres -c '\du $name' | grep '$name'",
            require => Service['postgresql'],
        }
    }
}
