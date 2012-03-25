class phpbb::base {
    $db = 'phpbb'
    $user = 'phpbb'
    $forums_dir = '/var/www/forums/'

    include apache::mod::php

    package {['php-gd',
              'php-xml',
              'php-zlib',
              'php-ftp',
              'php-apc',
              'php-magickwand',
              'php-pgsql',
              'php-ldap']: }

    package { 'perl-DBD-Pg': }

    file { '/usr/local/bin/phpbb_apply_config.pl':
        mode   => '0755',
        source => 'puppet:///modules/phpbb/phpbb_apply_config.pl',
    }

    $pgsql_password = extlookup('phpbb_pgsql','x')
    postgresql::remote_user { $user:
        password => $pgsql_password,
    }

    file { $forums_dir:
        ensure => directory,
    }

    # TODO check that everything is locked down
    apache::vhost::base { "forums.$::domain":
        content => template('phpbb/forums_vhost.conf'),
    }

    apache::vhost::base { "ssl_forums.$::domain":
        use_ssl => true,
        vhost   => "forums.$::domain",
        content => template('phpbb/forums_vhost.conf'),
    }

    file { '/etc/httpd/conf/vhosts.d/forums.d/':
        ensure => directory,
    }
}


