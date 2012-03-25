define apache::vhost::base ($content = '',
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
        $httpd_logdir = '/var/log/httpd'
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
            if $wildcard_sslcert != true {
                openssl::self_signed_cert{ $real_vhost:
                    directory => '/etc/ssl/apache/',
                    before    => Apache::Config["/etc/httpd/conf/vhosts.d/$filename"],
                }
            }
        }

        if $enable_public_html {
            include apache::mod::public_html
        }

        apache::config { "/etc/httpd/conf/vhosts.d/$filename":
            content => template('apache/vhost_base.conf')
        }
    }
}
