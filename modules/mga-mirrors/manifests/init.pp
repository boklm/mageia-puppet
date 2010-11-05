class mga-mirrors {
    
    $vhost = "mirrors.$domain"

    include apache::mod_fcgid

    package { 'mga-mirrors':
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
        content => template("mga-mirrors/mirrors_vhost.conf")
    }
 
    $password = extlookup("mga_mirror_password")
 
    file { "mga-mirrors.ini": 
        path => "/etc/mga-mirrors.ini",    
        ensure => "present",
        owner => apache,
        group => apache,
        mode => 600,
        content => template("mga-mirrors/mga-mirrors.ini")
    }
}
