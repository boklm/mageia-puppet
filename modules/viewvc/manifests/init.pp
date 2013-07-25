class viewvc {
    include apache::mod::fastcgi
    include viewvc::var
    package {['viewvc',
              'python-svn',
              'python-flup']: }

    # http_expiration_time = 600
    # svn_roots = admin: svn://svn.mageia.org/svn/adm/

    file { '/etc/viewvc/viewvc.conf':
        content => template($viewvc::var::tmpl_viewvc_conf),
        notify  => Service['apache'],
        require => Package['viewvc'],
    }

    apache::webapp_other { 'viewvc':
        webapp_file => 'viewvc/webapp.conf',
    }

    mga_common::local_script { 'kill_viewvc':
        content => template('viewvc/kill_viewvc.sh'),
    }

    cron { 'kill_viewvc':
        command     => '/usr/local/bin/kill_viewvc',
        hour        => '*',
        minute      => '*/5',
        user        => 'apache',
        environment => 'MAILTO=root',
    }

    $robotsfile = '/var/www/viewvc/robots.txt'
    file { $robotsfile:
        ensure => present,
        mode   => 0644,
        owner  => root,
        group  => root,
        source => 'puppet:///modules/viewvc/robots.txt',
    }

    $vhost_aliases = {
        '/viewvc' => '/var/www/viewvc/',
        '/robots.txt' => $robotsfile,
        '/'       => '/usr/share/viewvc/bin/wsgi/viewvc.fcgi/'
    }
    apache::vhost::base { $viewvc::var::hostname:
        aliases => $vhost_aliases,
        content => template('viewvc/vhost.conf'),
    }
    apache::vhost::base { "ssl_${viewvc::var::hostname}":
        vhost   => $viewvc::var::hostname,
        use_ssl => true,
        aliases => $vhost_aliases,
    }
}

