class epoll {

    include apache::mod_fastcgi

    $vhost = "epoll.$domain"
    package { 'Epoll':
        ensure => installed
    }

    # add a apache vhost
    file { "$vhost.conf":
        path => "/etc/httpd/conf/vhosts.d/$vhost.conf",
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
