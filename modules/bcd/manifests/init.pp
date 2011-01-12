class bcd {
    $bcd_login = 'bcd'
    $bcd_home = '/home/bcd'

    class base {
	include sudo

        buildsystem::sshuser { $bcd_login:
	    homedir => $bcd_home,
 	    comment => "User for creating ISOs",
	}

	package { bcd:
	    ensure => 'installed',
	}

       file { "/etc/sudoers.d/bcd":
            owner => root,
            group => root,
            mode => 440,
            content => template("bcd/sudoers.bcd")
        }
    }

    define ssh_access($type, $key) {
	ssh_authorized_key{$name:
		type => $type,
		key => $key,
		user => $bcd_login,
	}
    }
}
