class apache {
    define vhost_redirect_ssl() {
        apache::vhost::base { "redirect_ssl_$name":
            vhost => $name,
            content => template("apache/vhost_ssl_redirect.conf")
        }
    }

    define vhost_catalyst_app($script, $location = '', $process = 4, $use_ssl = false, $vhost = false) {

        include apache::mod::fastcgi
        apache::vhost::base { $name:
            vhost => $vhost,
            use_ssl => $use_ssl,
            content => template("apache/vhost_catalyst_app.conf"),
        }
    }

    define vhost_django_app($module = false, $module_path = false, $use_ssl = false, $aliases= {}) {
        include apache::mod::wsgi
        apache::vhost::base { $name:
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
        apache::vhost::base { $name:
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
        apache::vhost::base { $name:
            location => $location,
        } 
    } 

    define vhost_redirect($url,
                          $vhost = false,
                          $use_ssl = false) {
        include apache::base
        apache::vhost::base { $name:
            use_ssl => $use_ssl,
            vhost => $vhost,
            content => template("apache/vhost_redirect.conf"),
        } 
    } 

    define vhost_reverse_proxy($url,
                               $vhost = false, 
                               $use_ssl = false) {
        include apache::mod::proxy
        apache::vhost::base { $name:
            use_ssl => $use_ssl,
            vhost => $vhost,
            content => template("apache/vhost_reverse_proxy.conf")
        } 
    }

}
