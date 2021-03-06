class apache::base {
    include apache::var

    package { 'apache-mpm-prefork': }

    package { $apache::var::pkg_conf: }

    service { 'httpd':
        alias     => 'apache',
        subscribe => [ Package['apache-mpm-prefork'] ],
    }

    exec { 'service httpd configtest':
        refreshonly => true,
        notify      => Service['apache'],
    }

    apache::config {
        '/etc/httpd/conf.d/customization.conf':
            content => template('apache/customization.conf'),
            require => Package[$apache::var::pkg_conf];
        '/etc/httpd/conf/vhosts.d/00_default_vhosts.conf':
            content => template('apache/00_default_vhosts.conf'),
            require => Package[$apache::var::pkg_conf];
    }

    file { '/etc/logrotate.d/httpd':
        content => template('apache/logrotate')
    }
}
