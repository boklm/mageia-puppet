class bcd {
    class variable {
        $bcd_login = 'bcd'
        $bcd_home = '/home/bcd'
	$public_isos = "$bcd_home/public_html/isos"
	$isomakers_group = 'mga-iso_makers'
    }

    class base inherits variable {
	include sudo

        group { $bcd_login: }

        user { $bcd_login:
            homedir => $bcd_home,
            comment => "User for creating ISOs",
	    }

	file { $public_isos:
	    ensure => directory,
	    owner => $bcd_login,
	    group => $bcd_login,
	    mode => 755,
	}

        #package { bcd:
	#    ensure => 'installed',
        #}

        sudo::sudoers_config { "bcd":
	    content => template("bcd/sudoers.bcd")
        }

	file { "/var/lib/bcd":
	    ensure => directory,
	    owner => $bcd_login,
	    group => $bcd_login,
	    mode => 755,
	}

    }

    class web inherits base {
        apache::vhost_base { "bcd.$domain":
	    location => "$bcd_home/public_html",
	    content => template('bcd/vhost_bcd.conf'),
	}
	file {"htaccess":
	    path => "$bcd_home/public_html/.htaccess",
	    ensure => present,
	    owner => bcd,
	    group => bcd,
	    mode => 755,
	    content => template("bcd/.htaccess")
	}
	file {"htpasswd":
            path => "$bcd_home/public_html/.htpasswd",
            ensure => present,
            owner => bcd,
            group => bcd,
            mode => 755,
            content => template("bcd/.htpasswd")
        }
    }

    class rsync inherits base {
        class { rsyncd:
		rsyncd_conf => 'bcd/rsyncd.conf'
	}
    }
}
