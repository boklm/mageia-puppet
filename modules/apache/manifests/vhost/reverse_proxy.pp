define apache::vhost::reverse_proxy($url,
                                    $vhost = false,
                                    $use_ssl = false,
                                    $content = '') {
    include apache::mod::proxy
    apache::vhost::base { $name:
        use_ssl => $use_ssl,
        vhost   => $vhost,
        content => template('apache/vhost_reverse_proxy.conf')
    }
}
