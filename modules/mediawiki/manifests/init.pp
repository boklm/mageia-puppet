class mediawiki {
    class base inherits config {

        include apache::mod_php

        package { ['mediawiki-minimal','mediawiki-ldapauthentication']: }

        file { $root:
            ensure => directory,
        }
      
        file { "/usr/local/bin/init_wiki.php":
             mode => 755,
             source => 'puppet:///modules/mediawiki/init_wiki.php',
        }
 
        $user = "mediawiki"
 
        postgresql::remote_user { $user:
            password => sprintf('%s', $config::pgsql_password),
        }

        # TODO create the ldap user   

	if $vhost {
	    apache::vhost_redirect_ssl { $vhost: }

	    apache::vhost_base { "ssl_$vhost":
		location => $root,
		use_ssl => true,
		vhost => $vhost,
		content => template("mediawiki/wiki_vhost.conf"),
	    }
	}



        # add index.php
    }        

    # do wiki basic installation

    define instance($title, $wiki_settings = '', $skinsdir = '/usr/share/mediawiki/skins') {

        include mediawiki::base

        $path = $name
        $lang = $name
        $wiki_root = "$mediawiki::base::root/$path"
        $db_name = "mediawiki_$name"
        $db_user = "$mediawiki::base::user"
        $db_password = "$mediawiki::config::pgsql_password"
        $secret_key = "$mediawiki::config::secretkey"

        file { "$wiki_root":
            ensure => directory 
        }

	file { "$wiki_root/skins":
	    ensure => link,
	    target => $skinsdir,
	    require => File["$wiki_root"],
	}

        exec { "wikicreate $name":
            command => "mediawiki-create $wiki_root",
            cwd => "$mediawiki::base::root",
            require => [File["$wiki_root"],Package['mediawiki-minimal']],
            creates => "$wiki_root/index.php",
        }

        postgresql::remote_database { "$db_name":
            user => $db_user,
            callback_notify => Exec["deploy_db $name"], 
        }

        exec { "deploy_db $name":
            command => "php /usr/local/bin/init_wiki.php $wiki_root", 
            refreshonly => true,
            onlyif => "test -d $wiki_root/config",
        }
        $ldap_password = $config::ldap_password

        file { "$wiki_root/LocalSettings.php":
	    owner => apache,
	    mode => 600,
            content => template("mediawiki/LocalSettings.php"),
            # if LocalSettings is created first, the wikicreate script
            # do not create a confg directory, and so it doesn't trigger deploy_db exec
            require => Exec["wikicreate $name"],
        }
    }
}
