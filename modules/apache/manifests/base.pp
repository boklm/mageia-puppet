class apache::base {

    # number of time the log file are rotated before being removed
    $httpdlogs_rotate = '24'

    $apache_user = 'apache'
    $apache_group = 'apache'

    package { 'apache-mpm-prefork':
        alias => 'apache',
    }

    if ($lsbdistrelease == '1') or ($lsbdistrelease == '2010.0') {
	package { 'apache-conf': }
    } else {
	package { 'apache': }
    }

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
            content => template('apache/customization.conf');
        '/etc/httpd/conf/vhosts.d/00_default_vhosts.conf':
            content => template('apache/00_default_vhosts.conf');
    }

    file { '/etc/logrotate.d/httpd':
        content => template('apache/logrotate')
    }
}
