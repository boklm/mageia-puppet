class phpbb {
    class base {
        $db = "phpbb"
        $user = "phpbb"

        include apache::mod_php

        package { ["php-gd",
                   "php-xml",
                   "php-zlib",
                   "php-ftp",
                   "php-apc",
                   "php-magickwand",
                   "php-pgsql",
                   "php-ldap", ] : }

        package { "perl-DBD-Pg": }

        file { "/usr/local/bin/phpbb_apply_config.pl":
             mode => 755,
             source => 'puppet:///modules/phpbb/phpbb_apply_config.pl',
        }

        $pgsql_password = extlookup("phpbb_pgsql",'x')
        postgresql::remote_user { $user:
            password => $pgsql_password,
        }

        $forums_dir = "/var/www/forums/"
        file { "$forums_dir":
            ensure => directory,
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

       file { "/etc/httpd/conf/vhosts.d/forums.d/":
            ensure => directory,
        } 

    }

    define phpbb_config($key, $value, $database) {
        exec { "phpbb_apply $name":
            command => "/usr/local/bin/phpbb_apply_config.pl $key",
            user => root,
            environment => ["PGDATABASE=$database", 
                            "PGUSER=$phpbb::base::user", 
                            "PGPASSWORD=$phpbb::base::pgsql_password", 
                            "PGHOST=pgsql.$domain", 
                            "VALUE=$value"],
            require => File["/usr/local/bin/phpbb_apply_config.pl"],
        }
    }

    define redirection_instance($url) {
        $lang = $name
        file { "/etc/httpd/conf/vhosts.d/forums.d/redirect_$name.conf":
            content => template("phpbb/forums_redirect.conf"),
            notify => Service['apache'],
        }
    }

    define databases(){
        Phpbb::Locale_db <<| |>>
    }
 
    define locale_db($tag = "default",
                     $user = $phpbb::base::user) {
        postgresql::database { $name:
            description => "$lang db for phpbb forum",
            user => $user,
            tag => $tag,
    # this break due to the way it is remotely declared
    # this should only be a issue in case of bootstrapping again 
    #        require => Postgresql::User[$user]
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

        # list found by reading ./install/install_install.php
        # end of check_server_requirements ( 2 loops )
        
        $writable_dirs = ['cache',
                'images/avatars/upload',
                'files',
                'store' ] 
        
        $dir_names = regsubst($writable_dirs,'^',"$forums_dir/$lang/phpBB/")

        file { $dir_names:
            ensure => directory,
            owner => apache,
            require => Exec["git_clone $lang"],
        }

        file { "$forums_dir/$lang/phpBB/config.php":
            content => template("phpbb/config.php"),
        }

        @@phpbb::locale_db { $database:
            user => $user,
        }

        Phpbb_config {
            database => $database,
        }

        $ldap_password = extlookup("phpbb_ldap",'x')

        phpbb_config {
            "ldap_user/$lang":
                key => "ldap_user", value => "cn=phpbb-$hostname,ou=System Accounts,$dc_suffix";
            "ldap_server/$lang":
                key => "ldap_server", value => "ldaps://ldap.$domain ldaps://ldap-slave-1.$domain";
            "ldap_password/$lang":
                key => "ldap_password", value => $ldap_password;
            "ldap_base_dn/$lang":
                key => "ldap_base_dn", value => "ou=People,$dc_suffix";
            "auth_method/$lang":
                key => "auth_method", value => "ldap";
            "ldap_mail/$lang":
                key => "ldap_mail", value => "mail";
            "ldap_uid/$lang":
                key => "ldap_uid", value => "uid";
            "cookie_domain/$lang":
                key => "cookie_domain", value => "forums.$domain";
            "server_name/$lang":
                key => "server_name", value => "forums.$domain";
            "default_lang/$lang":
                key => "default_lang", value => $lang;
        }

    }
}
