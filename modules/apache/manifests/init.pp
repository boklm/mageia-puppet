class apache {
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

}
