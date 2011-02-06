class bcd {
    class variable {
        $bcd_login = 'bcd'
        $bcd_home = '/home/bcd'
	$isomakers_group = 'mga-iso_makers'
    }

    class base inherits variable {
	include sudo

        buildsystem::sshuser { $bcd_login:
            homedir => $bcd_home,
            comment => "User for creating ISOs",
	}

        package { bcd:
	    ensure => 'installed',
        }

        sudo::sudoers_config { "bcd":
	    content => template("bcd/sudoers.bcd")
        }

	file { "/var/lib/bcd":
	    ensure => directory
	    owner => $bcd_login,
	    group => $bcd_login,
	    mode => 755,
	}

    }
}
