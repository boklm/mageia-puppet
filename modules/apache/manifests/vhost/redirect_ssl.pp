define apache::vhost::redirect_ssl() {
    apache::vhost::base { "redirect_ssl_$name":
        vhost   => $name,
        content => template('apache/vhost_ssl_redirect.conf')
    }
}
