class epoll {

    $vhost = "epoll.$domain"

    package { 'Epoll':
        ensure => installed
    }
    
    apache::vhost_catalyst_app { $vhost:
        script => "/usr/bin/epoll_fastcgi.pl", 
        use_ssl => true, 
        require => Package['Epoll']
    }

    openssl::self_signed_cert{ "$vhost":
        directory => "/etc/ssl/apache/"
    }

    apache::vhost_redirect_ssl { $vhost: }
     
    $password = extlookup("epoll_password",'x')

    @@postgresql::user { 'epoll':
        password => $password,
    }

 
    file { "epoll.yml": 
        path => "/etc/epoll.yml",    
        ensure => "present",
        owner => root,
        group => apache,
        mode => 640,
        content => template("epoll/epoll.yml")
    }

    @@postgresql::database { 'epoll':
        description => "Epoll database",
        user => "epoll",
        require => Postgresql::User['epoll']
    }

}
