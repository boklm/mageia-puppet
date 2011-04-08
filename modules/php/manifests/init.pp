class php {
    class base {
        $php_sender_email = "root@$domain"
	$php_date_timezone = "UTC"

        package {"php-ini":
	    ensure => installed,
	}

	file { "/etc/php.ini":
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 644,
	    require => Package['php-ini'],
	    content => template('php/php.ini'),
	}
    }

    class php_cli inherits base {
	package {"php-cli":
	    ensure => installed,
	}
    }

    # if you want to use apache-mod_php, include apache::mod_php
}
