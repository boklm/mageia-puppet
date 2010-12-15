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

    apache::vhost_redirect_ssl { $vhost: }
     
    $pgsql_password = extlookup("epoll_pgsql",'x')

    @@postgresql::user { 'epoll':
        password => $pgsql_password,
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
