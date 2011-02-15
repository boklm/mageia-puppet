class phpbb {
    $database = "phpbb"
    $user = "phpbb"

    include apache::mod_php
    include mysql

    package { ["php-gd","php-xml","php-zlib","php-ftp","php-magickwand" ] :
        ensure => installed
    }

    package { "perl-DBD-Pg":
        ensure => installed
    }

    file { "/usr/local/bin/phpbb_apply_config.pl":
         ensure => present,
         owner => root,
         group => root,
         mode => 755,
         source => 'puppet:///modules/phpbb/phpbb_apply_config.pl',
    }

    # TODO phpbb config
    # cookie_domain 
    # board_contact
    # 
    define phpbb_config($value) {
        exec { "/usr/local/bin/phpbb_apply_config.pl $name":
            user => root,
            environment => "PGDATABASE=$database PGUSER=$user PGPASSWORD=$password PGHOST=pgsql.$domain VALUE=$value",
            require => File["/usr/local/bin/phpbb_apply_config.pl"],
        }
    }

    phpbb_config { "ldap_user":
        value => "cn=phpbb-friteuse,ou=System Accounts,$dc_suffix",
    }

    phpbb_config { "ldap_server":
        value => "ldap.$domain",
    }

    $ldap_password = extlookup("phpbb_ldap",'x')
    phpbb_config { "ldap_password":
        value => $ldap_password,
    }

    phpbb_config { "ldap_base_dn":
        value => "ou=People,$dc_suffix",
    }



    # TODO git checkout of the code

    # TODO phpbb database configuration
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
