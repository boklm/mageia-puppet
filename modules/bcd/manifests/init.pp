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

    define ssh_access($type, $key) {
        include bcd::variable
        ssh_authorized_key{$name:
            type => $type,
            key => $key,
            user => $bcd_login,
        }
    }
}
