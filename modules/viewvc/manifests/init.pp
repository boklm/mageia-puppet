class viewvc {
    package { ['viewvc','python-svn']:
        ensure => installed
    }
    # http_expiration_time = 600
    # svn_roots = admin: svn://svn.mageia.org/svn/adm/

    file { 'viewvc.conf':
        ensure => present,
        path => '/etc/viewvc/viewvc.conf',
        content => template('viewvc/viewvc.conf'),
        notify => Service['apache'],
        requires => Package['viewvc']
    }

    file { 'webapps.d/viewvc.conf':
        ensure => present,
        path => '/etc/httpd/conf/webapps.d/viewvc.conf',
        content => template('viewvc/webapp.conf'),
        notify => Service['apache'],
    }

    # need newer version of viewvc
    apache::vhost_wsgi{ "viewvc.$domain":
        wsgi_path => "/usr/share/viewvc/bin/wsgi/viewvc.wsgi",
        aliases => { "/viewvc" => "/var/www/viewvc/" }, 
    }
}

