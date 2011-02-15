class phpbb {
    $database = "phpbb"
    $user = "phpbb"

    include apache::mod_php
    include mysql

    package { ["php-gd","php-xml","php-zlib","php-ftp","php-magickwand" ] :
        ensure => installed
    }

    # TODO ldap account configuration

    # TODO apache setup

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
