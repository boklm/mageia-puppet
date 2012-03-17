class postgresql {
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
