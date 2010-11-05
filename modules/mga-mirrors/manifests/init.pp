class mga-mirrors {
    
    $vhost = "mirrors.$domain"

    package { 'mga-mirrors':
        ensure => installed
    }

    apache::vhost_catalyst_app { $vhost:
        script => "/usr/bin/mga_mirrors_fastcgi.pl" 
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
