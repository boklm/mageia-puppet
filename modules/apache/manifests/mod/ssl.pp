class apache::mod::ssl {
    include apache::base
    file { '/etc/ssl/apache/':
        ensure => directory
    }

    openssl::self_signed_cert{ 'localhost':
        directory => '/etc/ssl/apache/',
        before    => Apache::Config['/etc/httpd/conf/vhosts.d/01_default_ssl_vhost.conf'],
    }

    package { 'apache-mod_ssl': }

    apache::config {
        '/etc/httpd/conf/vhosts.d/01_default_ssl_vhost.conf':
            content => template('apache/01_default_ssl_vhost.conf');
        '/etc/httpd/conf.d/ssl.conf':
            content => template('apache/ssl.conf');
    }
}
