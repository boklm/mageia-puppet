class epoll {

    $vhost = "epoll.$domain"

    package { 'Epoll':
        ensure => installed
    }
    
    apache::vhost_catalyst_app { $vhost:
        script => "/usr/bin/epoll_fastcgi.pl", 
        require => Package['Epoll']
    }
     
    $password = extlookup("epoll_password",'x')
 
    file { "epoll.yml": 
        path => "/etc/epoll.yml",    
        ensure => "present",
        owner => root,
        group => apache,
        mode => 640,
        content => template("epoll/epoll.yml")
    }
}
