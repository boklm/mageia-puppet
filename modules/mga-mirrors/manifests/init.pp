class mga-mirrors {
    
    $vhost = "mirrors.$domain"

    package { 'mga-mirrors':
        ensure => installed
    }

    apache::vhost_catalyst_app { $vhost:
        script => "/usr/bin/mga_mirrors_fastcgi.pl", 
        require => Package['mga-mirrors']
    }

    $password = extlookup("mga_mirror_password",'x')
 
    file { "mga-mirrors.ini": 
        path => "/etc/mga-mirrors.ini",    
        ensure => "present",
        owner => root,
        group => apache,
        mode => 640,
        content => template("mga-mirrors/mga-mirrors.ini"),
        require => Package['mga-mirrors']
    }
}
