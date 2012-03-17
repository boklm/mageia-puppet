define mediawiki::instance( $title,
                            $wiki_settings = '',
                            $skinsdir = '/usr/share/mediawiki/skins') {

    include mediawiki::base

    $path = $name
    $lang = $name
    $wiki_root = "$mediawiki::base::root/$path"
    $db_name = "mediawiki_$name"
    $db_user = $mediawiki::base::user
    $db_password = $mediawiki::config::pgsql_password
    $secret_key = $mediawiki::config::secretkey
    $ldap_password = $mediawiki::config::ldap_password

    file { $wiki_root:
        ensure => directory
    }

    file { "$wiki_root/skins":
        ensure  => link,
        target  => $skinsdir,
        require => File[$wiki_root],
    }

    exec { "wikicreate $name":
        command => "mediawiki-create $wiki_root",
        cwd     => $mediawiki::base::root,
        require => [File[$wiki_root],Package['mediawiki-minimal']],
        creates => "$wiki_root/index.php",
    }

    postgresql::remote_database { $db_name:
        user            => $db_user,
        callback_notify => Exec["deploy_db $name"],
    }

    exec { "deploy_db $name":
        command     => "php /usr/local/bin/init_wiki.php $wiki_root",
        refreshonly => true,
        onlyif      => "test -d $wiki_root/config",
    }

    file { "$wiki_root/LocalSettings.php":
        owner   => 'apache',
        mode    => '0600',
        content => template('mediawiki/LocalSettings.php'),
        # if LocalSettings is created first, the wikicreate script
        # do not create a confg directory, and so it doesn't
        # trigger deploy_db exec
        require => Exec["wikicreate $name"],
    }
}

