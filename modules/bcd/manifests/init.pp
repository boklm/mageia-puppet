class bcd {
    class variable {
        $bcd_login = 'bcd'
        $bcd_home = '/home/bcd'
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
    }
}
