class youri-check {
    class variable {
        $location = "/var/www/youri-check"
        $vhost = "check.$domain"
    }

    class check inherits variable {
	$user = 'youri'
	$home = '/var/tmp/youri'
	$outdir = "$home/www"
	$config = "/etc/youri/cauldron.conf"

	user { $user:
	    comment => "Youri Check",
	    ensure => present,
	    managehome => true,
	    home => $home,
        }

	package { ['perl-Youri-Media', 'youri-check', 'perl-DBD-SQLite'] :
            ensure => installed
	}

	cron { 'check':
	    command => "youri-check -c $config test && youri-check -c $config report",
	    hour => 6,
	}

	file { "$config":
	    ensure => present,
	    owner => $user,
	    mode => 640,
	    content => template("youri-check/check.conf"),
	}
    }

    class website inherits variable {
	file { "$location":
	    ensure => directory,
            owner => apache,
	    mode => 755
	}

        apache::vhost_simple { $vhost:
            location => $location,
        }
    }
}
