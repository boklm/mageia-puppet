class phpbb {
    $database = "phpbb"
    $user = "phpbb"

    include apache::mod_php
    include mysql

    package { ["php-gd","php-xml","php-zlib","php-ftp","php-magickwand" ] :
        ensure => installed
    }

    # TODO ldap account configuration

    file { "/usr/local/bin/phpbb_apply_config.pl":
         ensure => present,
         owner => root,
         group => root,
         mode => 755,
         source => 'puppet:///modules/phpbb/phpbb_apply_config.pl',
    }

    # TODO ldap account configuration
    # ldap_user
    # ldap_server
    # ldap_password ldap_base_dn cookie_domain 
    # board_contact
    # 
    define phpbb_config($value) {
        exec { "/usr/local/bin/phpbb_apply_config.pl $name":
            user => root,
            environment => "PGDATABASE=$database PGUSER=$user PGPASSWORD=$password PGHOST=pgsql.$domain VALUE=$value",
            require => File["/usr/local/bin/phpbb_apply_config.pl"],
        }
    }

    # TODO git checkout 

    $pgsql_password = extlookup("phpbb_pgsql",'x')
    @@postgresql::user { $user:
        password => $pgsql_password,
    }

    @@postgresql::database { $database:
        description => "Phpbb database",
        user => $user,
        require => Postgresql::User[$user]
    }
}
