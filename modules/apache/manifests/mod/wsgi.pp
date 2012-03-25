class apache::mod::wsgi {
    include apache::base
    package { 'apache-mod_wsgi': }

    file { '/usr/local/lib/wsgi':
        ensure => directory,
    }

    apache::config { '/etc/httpd/conf.d/mod_wsgi.conf':
        content => template('apache/mod_wsgi.conf'),
    }
}
