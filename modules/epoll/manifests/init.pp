class epoll {
    include epoll::var

    package { 'Epoll': }

    apache::vhost::catalyst_app { $epoll::var::vhost:
        script  => '/usr/bin/epoll_fastcgi.pl',
        use_ssl => true,
        require => Package['Epoll']
    }

    apache::vhost::redirect_ssl { $epoll::var::vhost: }

    postgresql::remote_db_and_user { $epoll::var::db_name:
        description => 'Epoll database',
        password    => $epoll::var::db_password,
    }

    file { 'epoll.yml':
        path    => '/etc/epoll.yml',
        group   => 'apache',
        mode    => '0640',
        content => template('epoll/epoll.yml')
    }
}
