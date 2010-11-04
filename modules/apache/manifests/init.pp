class apache {

    class base {
        package { "apache-mpm-prefork":
            ensure => installed
        }
    
        service { httpd: 
            alias => apache,
            ensure => running,
            subscribe => [ Package['apache-mpm-prefork'] ],
        }
    }
    
    class mod_php inherits base {
        package { "apache-mod_php":
            ensure => installed
        }
    }

    class mod_perl inherits base {
        package { "apache-mod_perl":
            ensure => installed
        }
    }

    class mod_fcgid inherits base {
        package { "apache-mod_fcgid":
            ensure => installed
        }
    }


    class mod_wsgi inherits base {
        package { "apache-mod_wsgi":
            ensure => installed
        }
    }
}
