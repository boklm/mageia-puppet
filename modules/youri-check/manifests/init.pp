class youri-check {
    class base {
        $vhost = "check.$domain"
        $user = 'youri'
        $config = '/etc/youri/cauldron.conf'
        $outdir = '/var/www/youri-check'
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
        $pgsql_db = 'youri_check'
        $pgsql_user = 'youri'
        $pgsql_password = extlookup('youri_pgsql','x')
        
        file { "$config":
            ensure => present,
            owner => $user,
            mode => 640,
            content => template("youri-check/check.conf"),
        }
    }

    class check inherits base {
        package { ['perl-Youri-Media', 'youri-check', 'perl-DBD-Pg']: }

        cron { 'check':
            command => "youri-check -c $config test",
            hour => "*",
            minute => 4,
            user => "$user",
	    environment => "MAILTO=root",
        }
    }

    class report inherits base {
        file { "$outdir":
            ensure => directory,
            owner => $user,
        }

        postgresql::remote_user { $pgsql_user:
            password => $pgsql_password,
        }

        postgresql::remote_database { $pgsql_db:
            description => "Youri Check results",
            user => $pgsql_user,
        }

        package { ['youri-check', 'perl-DBD-Pg']: }

        cron { 'check':
            command => "youri-check -c $config report",
            hour => "*",
            minute => 24,
            user => "$user",
        }

        apache::vhost_simple { $vhost:
            location => $outdir,
        }
    }
}
