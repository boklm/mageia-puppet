class epoll {

    $vhost = "epoll.$domain"

    package { 'Epoll':
        ensure => installed
    }
    
    apache::vhost_catalyst_app { $vhost:
        script => /usr/bin/epoll_fastcgi.pl 
    }
     
    $password = extlookup("epoll_password")
 
    file { "epoll.yml": 
        path => "/etc/epoll.yml",    
        ensure => "present",
        owner => apache,
        group => apache,
        mode => 600,
        content => template("epoll/epoll.yml")
    }
}
