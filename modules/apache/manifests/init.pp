class apache {

    class base {
        package { "apache-mpm-prefork":
            alias => apache,
            ensure => installed
        }
    
        service { httpd: 
            alias => apache,
            ensure => running,
            subscribe => [ Package['apache-mpm-prefork'] ],
        }

        file { "customization.conf":
            ensure => present,
            path => "/etc/httpd/conf.d/customization.conf",
            content => template("apache/customization.conf"),
            require => Package["apache"],
            notify => Service["apache"],
            owner => root,
            group => root,
            mode => 644,
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

    class mod_fastcgi inherits base {
        package { "apache-mod_fastcgi":
            ensure => installed
        }
    }

    class mod_wsgi inherits base {
        package { "apache-mod_wsgi":
            ensure => installed
        }
    }

    define vhost_redirect_ssl() {
        file { "redirect_ssl_$name.conf":
            path => "/etc/httpd/conf/vhosts.d/redirect_ssl_$name.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template("apache/vhost_ssl_redirect.conf")
        }
    }

    define vhost_catalyst_app($script, $process = 4, $use_ssl = false) {

        include apache::mod_fastcgi 

        file { "$name.conf":
            path => "/etc/httpd/conf/vhosts.d/$name.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template("apache/vhost_catalyst_app.conf")
        }
    }
}
