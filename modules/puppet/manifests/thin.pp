class puppet::thin {
    package { 'ruby-thin': }

    include apache::mod_ssl
    include apache::mod_proxy

    apache::vhost_other_app { 'puppet_proxy':
	vhost_file => 'puppet/apache_proxy_vhost.conf',
    }
   
    apache::config { "/etc/httpd/conf.d/puppet.conf":
        content => "Listen 8140",
    }

    $service_name = 'thin_puppet_master'
    file { '/etc/puppet/thin.yml':
	content => template('puppet/thin.yml'),
	notify => Service[$service_name],
    }

    file { '/usr/local/share/puppet.config.ru':
        content => template('puppet/config.ru'),
    }

    service { $service_name:
        provider => base,
        require  => [Package['ruby-thin'], 
                     File['/etc/puppet/thin.yml'],
                     File['/usr/local/share/puppet.config.ru']],
        start    => 'thin -C /etc/puppet/thin.yml start',
        stop     => 'thin -C /etc/puppet/thin.yml stop',
        restart  => 'thin -C /etc/puppet/thin.yml restart',
    }
}
