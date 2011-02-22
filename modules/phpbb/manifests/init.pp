class phpbb {
    class base {
        $db = "phpbb"
        $user = "phpbb"

        include apache::mod_php
        include mysql

        package { ["php-gd","php-xml","php-zlib","php-ftp","php-magickwand","php-pgsql" ] :
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

        $pgsql_password = extlookup("phpbb_pgsql",'x')
        @@postgresql::user { $user:
            password => $pgsql_password,
        }

        $forums_dir = "/var/www/forums/"
        file { "$forums_dir":
            ensure => directory,
            owner => root,
            group => root,
        }
        # TODO add a ssl counterpart
        # TODO check that everything is locked down
        apache::vhost_base { "forums.$domain":
            content => template("phpbb/forums_vhost.conf"),
        }

        apache::vhost_base { "ssl_forums.$domain":
            use_ssl => true,
            vhost => "forums.$domain",
            content => template("phpbb/forums_vhost.conf"),
        }

    }

    define phpbb_config($value) {
        exec { "/usr/local/bin/phpbb_apply_config.pl $name":
            user => root,
            environment => ["PGDATABASE=$phpbb::base::database", 
                            "PGUSER=$phpbb::base::user", 
                            "PGPASSWORD=$phpbb::base::pgsql_password", 
                            "PGHOST=pgsql.$domain", 
                            "VALUE=$value"],
            require => File["/usr/local/bin/phpbb_apply_config.pl"],
        }
    }

    # TODO find a way to avoid all the phpbb::base prefix
    define instance() {
        include phpbb::base

        $lang = $name
        $database = "${phpbb::base::db}_$lang"
        
        $user = $phpbb::base::user
        $pgsql_password = $phpbb::base::pgsql_password
        $forums_dir = $phpbb::base::forums_dir

        include git::client
        exec { "git_clone $lang":
            command =>"git clone git://git.$domain/forum/ $lang",
            cwd => $forums_dir,
            creates => "$forums_dir/$lang",
            require => File["$forums_dir"],
            notify => Exec["rm_install $lang"],
        }

        # remove this or the forum will not work ( 'board disabled' )
        # maybe it would be better to move this elsehwere, I 
        # am not sure ( and in any case, that's still in git )
        exec { "rm_install $lang":
            command => "rm -Rf $forums_dir/$lang/phpBB/install",
            onlyif => "test -d $forums_dir/$lang/phpBB/install",
        }

        # TODO manage the permission of the various subdirectories
        $writable_dir = ['cache']
        file { "$forums_dir/$lang/phpBB/$writable_dir":
            ensure => directory,
            owner => apache,
            group => root,
            mode => 755,
            require => Exec["git_clone $lang"],
        }

        file { "$forums_dir/$lang/phpBB/config.php":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            content => template("phpbb/config.php"),
        }


        @@postgresql::database { $database:
            description => "Phpbb database",
            user => $user,
            require => Postgresql::User[$user]
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

        phpbb_config { "auth_method":
            value => "ldap",
        }

        phpbb_config { "ldap_mail":
            value => "mail",
        }

        phpbb_config { "ldap_uid":
            value => "uid",
        }

        phpbb_config { "cookie_domain":
            value => "forums.$domain",
        }

        phpbb_config { "server_name":
            value => "forums.$domain",
        }


    }
}
