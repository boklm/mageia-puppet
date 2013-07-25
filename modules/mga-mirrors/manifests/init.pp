class mga-mirrors {

    $vhost = "mirrors.$::domain"

    package { 'mga-mirrors': }

    apache::vhost::catalyst_app { $vhost:
        script  => '/usr/bin/mga_mirrors_fastcgi.pl',
        require => Package['mga-mirrors'],
    }

    apache::vhost::base { "ssl_$vhost":
        vhost   => $vhost,
        use_ssl => true,
        aliases => {
            '/' => '/usr/bin/mga_mirrors_fastcgi.pl/',
        },
    }

    $pgsql_password = extlookup('mga_mirror_pgsql','x')

    postgresql::remote_db_and_user { 'mirrors':
        password    => $pgsql_password,
        description => 'Mirrors database',
    }

    file { '/etc/mga-mirrors.ini':
        group   => 'apache',
        mode    => '0640',
        content => template('mga-mirrors/mga-mirrors.ini'),
        require => Package['mga-mirrors']
    }

    file { '/etc/cron.d/mga_mirrors':
        content => template('mga-mirrors/cron-mga_mirrors'),
        require => Package['mga-mirrors']
    }
}
