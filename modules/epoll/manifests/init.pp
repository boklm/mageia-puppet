class epoll {

    include apache::mod_fcgid

    package { 'Epoll':
        ensure => installed
    }

    # add a apache vhost
    file { "epoll.$domain.conf":
        path => "/etc/httpd/conf/vhosts.d/$name.$domain.conf",
        ensure => "present",
        owner => root,
        group => root,
        mode => 644,
        notify => Service['apache'],
        content => template("epoll/epoll_vhost.conf")
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
