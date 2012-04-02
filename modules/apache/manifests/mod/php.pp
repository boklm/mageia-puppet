class apache::mod::php {
    include apache::base
    $php_date_timezone = 'UTC'

    package { 'apache-mod_php': }

    apache::config { '/etc/httpd/conf.d/mod_php.conf':
        content => template('apache/mod/php.conf'),
    }
}
