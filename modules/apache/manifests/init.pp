class apache {
    define vhost_catalyst_app($script, $location = '', $process = 4, $use_ssl = false, $vhost = false) {

        include apache::mod::fastcgi
        apache::vhost::base { $name:
            vhost => $vhost,
            use_ssl => $use_ssl,
            content => template("apache/vhost_catalyst_app.conf"),
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
