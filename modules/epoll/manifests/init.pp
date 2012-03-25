class epoll {

    $vhost = "epoll.$::domain"

    package { 'Epoll': }

    apache::vhost_catalyst_app { $vhost:
        script  => '/usr/bin/epoll_fastcgi.pl',
        use_ssl => true,
        require => Package['Epoll']
    }

    apache::vhost::redirect_ssl { $vhost: }

    $pgsql_password = extlookup('epoll_pgsql','x')

    postgresql::remote_db_and_user { 'epoll':
        description => 'Epoll database',
        password    => $pgsql_password,
    }

    file { 'epoll.yml':
        path    => '/etc/epoll.yml',
        group   => 'apache',
        mode    => '0640',
        content => template('epoll/epoll.yml')
    }
}
