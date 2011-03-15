class apache {

    class base {
        package { "apache-mpm-prefork":
            alias => apache,
            ensure => installed
        }
    
        package { "apache-conf":
            ensure => installed,
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
            require => Package["apache-conf"],
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
            require => Package["apache-conf"],
            content => template("apache/00_default_vhosts.conf")
        }

    }
    
    class mod_php inherits base {
        package { "apache-mod_php":
            ensure => installed
        }

        file { "/etc/httpd/conf.d/mod_php.conf":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            require => Package['apache-conf'],
            content => template('apache/mod_php.conf'),
            notify => Service['apache'],
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

	file { "01_default_ssl_vhost.conf":
	    path => '/etc/httpd/conf/vhosts.d/01_default_ssl_vhost.conf',
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            require => Package["apache-conf"],
            content => template("apache/01_default_ssl_vhost.conf")
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

        file { "/etc/httpd/conf.d/mod_wsgi.conf":
            ensure => present,
            owner => root,
            group => root,
            mode => 644,
            require => Package['apache-conf'],
            content => template('apache/mod_wsgi.conf'),
            notify => Service['apache'],
        }

    }
    
    class mod_proxy inherits base {
        package { "apache-mod_proxy":
            ensure => installed
        }
    }

    class mod_public_html inherits base {
        package { "apache-mod_public_html":
            ensure => installed
        }
    }

    class mod_deflate inherits base {
   	package { "apache-mod_deflate":
	    ensure => installed
	}
    }

    define vhost_base($content = '',
                      $location = '/dev/null', 
                      $use_ssl = false,
                      $vhost = false,
                      $aliases = {},
                      $server_aliases = [],
                      $enable_public_html = false) {
        if ! $vhost {
            $real_vhost = $name
        } else {
            $real_vhost = $vhost
        }

        if $use_ssl {
            include apache::mod_ssl
	    if $wildcard_sslcert != 'true' {
		openssl::self_signed_cert{ "$real_vhost":
		    directory => "/etc/ssl/apache/",
		    before => File["$filename"],
		}
	    }
        }

        if $enable_public_html {
            include apache::mod_public_html
        }

        $filename = "$name.conf"
        file { "$filename":
            path => "/etc/httpd/conf/vhosts.d/$filename",
            ensure => "present",
            owner => root,
            group => root,
            mode => 644,
            notify => Service['apache'],
            require => Package['apache-conf'],
            content => template("apache/vhost_base.conf")
        }
    }

    define vhost_redirect_ssl() {
        vhost_base { "redirect_ssl_$name":
            vhost => $name,
            content => template("apache/vhost_ssl_redirect.conf")
        }
    }

    define vhost_catalyst_app($script, $location = '', $process = 4, $use_ssl = false) {

        include apache::mod_fastcgi 
        vhost_base { $name:
            use_ssl => $use_ssl,
            content => template("apache/vhost_catalyst_app.conf")
        }
    }

    define vhost_django_app($module = false, $module_path = false, $use_ssl = false, $aliases= {}) {
        include apache::mod_wsgi
        vhost_base { $name:
            use_ssl => $use_ssl,
            content => template("apache/vhost_django_app.conf"),
            aliases => $aliases,
        }
        
        # module is a ruby reserved keyword, cannot be used in templates
        $django_module = $module
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

    define vhost_wsgi($wsgi_path, $aliases = {}, $server_aliases = []) {
        include apache::mod_wsgi
        vhost_base { $name:
            aliases => $aliases,
            server_aliases => $server_aliases,
            content => template("apache/vhost_wsgi.conf")
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
            require => Package['apache-conf'],
            content => template($vhost_file)
        }
   }

    define vhost_simple($location) {
        include apache::base
        vhost_base { $name:
            location => $location,
        } 
    } 

    define vhost_redirect($url,
    			  $vhost = false,
			  $use_ssl = false) {
        include apache::base
        vhost_base { $name:
            use_ssl => $use_ssl,
            vhost => $vhost,
            content => template("apache/vhost_redirect.conf"),
        } 
    } 

    define vhost_reverse_proxy($url,
                               $vhost = false, 
                               $use_ssl = false) {
        include apache::mod_proxy
        vhost_base { $name:
            use_ssl => $use_ssl,
            vhost => $vhost,
            content => template("apache/vhost_reverse_proxy.conf")
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
            require => Package['apache-conf'],
            content => template($webapp_file)
        }
   }
}
