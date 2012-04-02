define apache::vhost::catalyst_app( $script,
                                    $location = '',
                                    $process = 4,
                                    $use_ssl = false,
                                    $vhost = false) {
    include apache::mod::fastcgi
    apache::vhost::base { $name:
        vhost   => $vhost,
        use_ssl => $use_ssl,
        content => template('apache/vhost_catalyst_app.conf'),
    }
}


