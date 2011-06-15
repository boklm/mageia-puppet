class mediawiki {
    class base {
        package { "mediawiki-minimal":
            ensure => installed,
        }
        
        $pgsql_password = extlookup("mediawiki_pgsql",'x')
        @@postgresql::user { $user:
            password => $pgsql_password,
        }

        # TODO create the ldap user   
        $ldap_password = extlookup('mediawiki_ldap','x')

        # TODO write the web configuration

        # add index.php
    }        

    # do wiki basic installation

    define instance {
        # define a db per instance
        # install / link source code
        # add config file
    }
}
