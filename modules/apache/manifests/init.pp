class apache {
    class base {

        # number of time the log file are rotated before being removed
        $httpdlogs_rotate = "24"

        $apache_user = 'apache'
        $apache_group = 'apache'

        package { "apache-mpm-prefork":
            alias => apache,
        }
    
        package { "apache-conf": }

        service { httpd: 
            alias => apache,
            subscribe => [ Package['apache-mpm-prefork'] ],
        }

        exec { "service httpd configtest":
            refreshonly => true,
            notify => Service["apache"],
        }

        apache::config {
            "/etc/httpd/conf.d/customization.conf":
                content => template("apache/customization.conf");
            "/etc/httpd/conf/vhosts.d/00_default_vhosts.conf":
                content => template("apache/00_default_vhosts.conf");
        }

        file { "/etc/logrotate.d/httpd":
            content => template("apache/logrotate")
        }
    }
    
   
    define vhost_base($content = '',
                      $location = '/dev/null', 
                      $use_ssl = false,
                      $vhost = false,
                      $aliases = {},
                      $server_aliases = [],
                      $access_logfile = false,
                      $error_logfile = false,
                      $options = [],
                      $enable_public_html = false) {
        include apache::base
        $httpd_logdir = "/var/log/httpd"
        $filename = "$name.conf"

        if ! $vhost {
            $real_vhost = $name
        } else {
            $real_vhost = $vhost
        }

        if ! $access_logfile {
            $real_access_logfile = "$httpd_logdir/${real_vhost}-access_log"
        } else {
            $real_access_logfile = $access_logfile
        }
        if ! $error_logfile {
            $real_error_logfile = "$httpd_logdir/${real_vhost}-error_log"
        } else {
            $real_error_logfile = $error_logfile
        }

        if $use_ssl {
            include apache::mod::ssl
            if $wildcard_sslcert != 'true' {
                openssl::self_signed_cert{ "$real_vhost":
                    directory => "/etc/ssl/apache/",
                    before => Apache::Config["/etc/httpd/conf/vhosts.d/$filename"],
                }
            }
        }

        if $enable_public_html {
            include apache::mod::public_html
        }

        apache::config { "/etc/httpd/conf/vhosts.d/$filename":
            content => template("apache/vhost_base.conf")
        }
    }

    define vhost_redirect_ssl() {
        vhost_base { "redirect_ssl_$name":
            vhost => $name,
            content => template("apache/vhost_ssl_redirect.conf")
        }
    }

    define vhost_catalyst_app($script, $location = '', $process = 4, $use_ssl = false, $vhost = false) {

        include apache::mod::fastcgi
        vhost_base { $name:
            vhost => $vhost,
            use_ssl => $use_ssl,
            content => template("apache/vhost_catalyst_app.conf"),
        }
    }

    define vhost_django_app($module = false, $module_path = false, $use_ssl = false, $aliases= {}) {
        include apache::mod::wsgi
        vhost_base { $name:
            use_ssl => $use_ssl,
            content => template("apache/vhost_django_app.conf"),
            aliases => $aliases,
        }
        
        # module is a ruby reserved keyword, cannot be used in templates
        $django_module = $module
        file { "$name.wsgi":
            path => "/usr/local/lib/wsgi/$name.wsgi",
            mode => 755,
            notify => Service['apache'],
            content => template("apache/django.wsgi"),
        }
    }

    define vhost_wsgi($wsgi_path, $aliases = {}, $server_aliases = []) {
        include apache::mod::wsgi
        vhost_base { $name:
            aliases => $aliases,
            server_aliases => $server_aliases,
            content => template("apache/vhost_wsgi.conf"),
        }
    }

   define vhost_other_app($vhost_file) {
        include apache::base
        apache::config { "/etc/httpd/conf/vhosts.d/$name.conf":
            content => template($vhost_file),
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
        include apache::mod::proxy
        vhost_base { $name:
            use_ssl => $use_ssl,
            vhost => $vhost,
            content => template("apache/vhost_reverse_proxy.conf")
        } 
    }

    define webapp_other($webapp_file) {
        include apache::base
        $webappname = $name
        apache::config { "/etc/httpd/conf/webapps.d/$webappname.conf":
            content => template($webapp_file),
        }
    }
}
