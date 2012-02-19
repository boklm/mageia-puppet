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
    }

    file { '/usr/local/share/puppet.config.ru':
        content => template('puppet/config.ru'),
    }
}
