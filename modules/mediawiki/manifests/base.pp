class mediawiki::base {
    include apache::mod::php
    $vhost = $mediawiki::config::vhost
    $root = $mediawiki::config::root

    package { ['mediawiki-minimal','mediawiki-ldapauthentication']: }

    file { $mediawiki::config::root:
        ensure => directory,
    }

    file { '/usr/local/bin/init_wiki.php':
        mode   => '0755',
        source => 'puppet:///modules/mediawiki/init_wiki.php',
    }

    $user = 'mediawiki'

    postgresql::remote_user { $user:
        password => $mediawiki::config::pgsql_password,
    }

    # TODO create the ldap user

    if $vhost {
        apache::vhost::redirect_ssl { $vhost: }

        apache::vhost::base { "ssl_$vhost":
            location => $root,
            use_ssl  => true,
            vhost    => $vhost,
            content  => template('mediawiki/wiki_vhost.conf'),
        }
    }
    # add index.php
}
