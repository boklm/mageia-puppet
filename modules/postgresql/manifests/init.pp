class postgresql {
    class server { 
        $pgsql_data = "/var/lib/pgsql/data/"
        $pg_version = '9.0'
    
        # missing requires is corrected in cooker, 
        # should be removed
        # once the fix is in a stable release 
        package { "postgresql${pg_version}-plpgsql":
            alias => "postgresql-plpgsql",
        }
    
        package { "postgresql${pg_version}-server":
            alias => "postgresql-server",
            require => Package['postgresql-plpgsql'],
        }
    
        service { postgresql:
            subscribe => Package["postgresql-server"],
        }
    
        exec { "service postgresql reload":
            refreshonly => true,
        }
   
        openssl::self_signed_splitted_cert { "pgsql.$domain":
            filename => "server",
            directory => $pgsql_data,
            owner => "postgres",
            group => "postgres",
            require => Package['postgresql-server']
        }


        file { '/etc/pam.d/postgresql':
            content => template("postgresql/pam"),
        }

        define config($content) {
            file { "$name":
                owner => postgres,
                group => postgres,
                mode => 600,
                content => $content,
                require => Package["postgresql-server"],
                notify => Exec['service postgresql reload'],
            }
        }


        $db = list_exported_ressources('Postgresql::Db_and_user')

        $forum_lang = list_exported_ressources('Phpbb::Locale_db')

        config {
            "$pgsql_data/pg_hba.conf": content => template("postgresql/pg_hba.conf");
            "$pgsql_data/pg_ident.conf": content => template("postgresql/pg_ident.conf");
            "$pgsql_data/postgresql.conf": content => template("postgresql/postgresql.conf");
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
                              $callback_notify = "", 
                              $password ) {

        @@postgresql::db_and_user { $name:
                                    callback_notify => $callback_notify, 
                                    tag => $tag,
                                    description => $description,
                                    password => $password
        }
        # fetch the exported ressources that should have been exported
        # once the db was created, and trigger a notify to the object passwed as callback_notify
        Postgresql::Database_callback <<| tag == $name |>> 
    }

    define remote_database($description = "", 
                           $user = "postgresql",
                           $callback_notify = "", 
                           $tag = "default")
    {

        
        @@postgresql::database { $name:
            description => $description,
            user => $user,
            callback_notify => $callback_notify, 
            tag => $tag,
            require => Postgresql::User[$user]
        }

        Postgresql::Database_callback <<| tag == $name |>> 
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
                       $callback_notify = "",
                       $password ) {

        postgresql::database { $name:
                   callback_notify => $callback_notify, 
                   description => $description,
                   user => $name,
		   require => Postgresql::User[$name],
        }

        postgresql::user { $name:
               password => $password
        }
        
    }

    define database_callback($callback_notify = '') {
        # dummy declaration, so we can trigger the notify
        if $callback_notify {
            exec { "callback $name":
                command => "true",
                notify => $callback_notify,
            }
        }
    }

   
}
