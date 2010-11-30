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

        file { "00_default_vhosts.conf":
            path => "/etc/httpd/conf/vhosts.d/00_default_vhosts.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template("apache/00_default_vhosts.conf")
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

    class mod_ssl inherits base {
        file { "/etc/ssl/apache/":
            ensure => directory
        }

        package { "apache-mod_ssl":
            ensure => installed
        }
    }

    class mod_wsgi inherits base {
        package { "apache-mod_wsgi":
            ensure => installed
        }

        file { "/usr/local/lib/wsgi":
            ensure => directory,
            owner => root,
            group => root,
            mode => 644,
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

    define vhost_catalyst_app($script, $location = '', $process = 4, $use_ssl = false) {

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

    define vhost_django_app($module, $module_path = '/usr/share') {
        include apache::mod_wsgi

        file { "$name.conf":
            path => "/etc/httpd/conf/vhosts.d/$name.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template("apache/vhost_django_app.conf")
        }

        # fichier django wsgi
        file { "$name.wsgi":
            path => "/usr/local/lib/wsgi/$name.wsgi",
            ensure => "present",
            owner => root,
            group => root,
            mode => 755,
            notify => Service['apache'],
            content => template("apache/django.wsgi")
        }
    }

   define vhost_other_app($vhost_file) {
        include apache::base
        file { "$name.conf":
            path => "/etc/httpd/conf/vhosts.d/$name.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template($vhost_file)
        }
   }

   define webapp_other($webapp_file) {
        include apache::base
        $webappname = $name
        file { "webapp_$name.conf":
            path => "/etc/httpd/conf/webapps.d/$webappname.conf",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            content => template($webapp_file)
        }
   }
}
