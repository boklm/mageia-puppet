class youri-check {
    class base {
        $vhost = "check.$domain"
        $user = 'youri'
        $home = '/var/lib/youri'

        user { $user:
            comment => 'Youri Check',
            home => $home,
        }

	file { $home:
	    ensure => directory,
	    owner => $user,
	    group => $user,
	}

	$pgsql_server = "$vhost"

	package { ['youri-check', 'perl-DBD-Pg', 'perl-Youri-Media']: }

    }

    define config($version) {
	include youri-check::base

	$config = "/etc/youri/$version.conf"
	$outdir = "/var/www/youri-check/$version"
	$pgsql_db = "youri_check_$version"
	$pgsql_server = $base::pgsql_server
	$pgsql_user = "youri$version"
	$pgsql_password = extlookup('youri_pgsql','x')

	file { "$config":
	    ensure => present,
            owner => $base::user,
	    mode => 640,
	    content => template("youri-check/$version.conf"),
	}
    }

    define check($version, $hour = "*", $minute = 0) {
	include youri-check::base
	$config = "/etc/youri/$version.conf"
	$pgsql_server = $base::pgsql_server
	$pgsql_db = "youri_check_$version"
	$pgsql_user = "youri$version"
	$pgsql_password = extlookup('youri_pgsql','x')

        postgresql::remote_user { $pgsql_user:
            password => $base::pgsql_password,
        }

        postgresql::remote_database { $pgsql_db:
            description => "Youri Check results",
            user => $pgsql_user,
        }
        cron { "check_$version":
            command => "youri-check -c $config test",
            hour => $hour,
            minute => $minute,
            user => $base::user,
	    environment => "MAILTO=root",
        }
    }

    define report_www {
        include youri-check::base
	$outdir = "/var/www/youri-check/"
        apache::vhost_simple { $base::vhost:
            location => $outdir,
        }
    }

    define report($version, $hour = "*", $minute = 20) {
        include youri-check::base

	$config = "/etc/youri/$version.conf"

	$outdir = "/var/www/youri-check/$version"
        file { "$outdir":
            ensure => directory,
            owner => $base::user,
	    mode => 755,
        }

        cron { "check_$version":
            command => "youri-check -c $config report",
            hour => $hour,
            minute => $minute,
            user => $base::user,
        }
    }
}
