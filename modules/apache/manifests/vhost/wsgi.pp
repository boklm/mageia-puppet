define apache::vhost::wsgi ($wsgi_path,
                            $aliases = {},
                            $server_aliases = []) {
    include apache::mod::wsgi
    apache::vhost::base { $name:
        aliases        => $aliases,
        server_aliases => $server_aliases,
        content        => template('apache/vhost_wsgi.conf'),
    }
}
