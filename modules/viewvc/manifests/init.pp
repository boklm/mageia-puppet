class viewvc {
    package { ['viewvc','python-svn','python-flup']: }
    # http_expiration_time = 600
    # svn_roots = admin: svn://svn.mageia.org/svn/adm/

    file { '/etc/viewvc/viewvc.conf':
        content => template('viewvc/viewvc.conf'),
        notify => Service['apache'],
        require => Package['viewvc'],
    }

    apache::webapp_other { 'viewvc':
        webapp_file => 'viewvc/webapp.conf',
    }

    local_script { "kill_viewvc":
	    content => template('viewvc/kill_viewvc.sh'),
    }

    cron { 'kill_viewvc':
        command => "/usr/local/bin/kill_viewvc",
        hour => "*",
        minute => "*/5",
        user => "apache",
        environment => "MAILTO=root",
    }

    apache::vhost_base { "svnweb.$domain":
        aliases => { "/viewvc" => "/var/www/viewvc/",
                     "/" => "/usr/share/viewvc/bin/wsgi/viewvc.fcgi/" }, 
        content => template("viewvc/vhost.conf")
    }
}

