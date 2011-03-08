class mga-mirrors {
    
    $vhost = "mirrors.$domain"

    package { 'mga-mirrors':
        ensure => installed
    }

    apache::vhost_catalyst_app { $vhost:
        script => "/usr/bin/mga_mirrors_fastcgi.pl", 
        require => Package['mga-mirrors']
    }

    $pgsql_password = extlookup("mga_mirror_pgsql",'x')

    postgresql::remote_user { 'mirrors':
        password => $pgsql_password,
    }

    postgresql::remote_database { 'mirrors':
        description => "Mirrors database",
        user => "mirrors",
    }
 
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
