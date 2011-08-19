class viewvc {
    package { ['viewvc','python-svn','python-flup']:
        ensure => installed
    }
    # http_expiration_time = 600
    # svn_roots = admin: svn://svn.mageia.org/svn/adm/

    file { 'viewvc.conf':
        ensure => present,
        path => '/etc/viewvc/viewvc.conf',
        content => template('viewvc/viewvc.conf'),
        notify => Service['apache'],
        require => Package['viewvc']
    }

    file { 'webapps.d/viewvc.conf':
        ensure => present,
        path => '/etc/httpd/conf/webapps.d/viewvc.conf',
        content => template('viewvc/webapp.conf'),
        notify => Service['apache'],
        require => Package['apache'],
    }

    $kill_viewvc_path = '/usr/local/sbin/kill_viewvc'
    file { "$kill_viewvc_path":
    	ensure => present,
	mode => 755,
	owner => root,
	group => root,
	content => template('viewvc/kill_viewvc.sh'),
    }

    cron { 'kill_viewvc':
	command => "$kill_viewvc_path",
	hour => "*",
	minute => "*/5",
	user => "apache",
	environment => "MAILTO=root",
    }

    # need newer version of viewvc
    apache::vhost_base { "svnweb.$domain":
        # TODO created a full fledged type
        aliases => { "/viewvc" => "/var/www/viewvc/",
                     "/" => "/usr/share/viewvc/bin/wsgi/viewvc.fcgi/" }, 
        content => template("viewvc/vhost.conf")
    }
}

