class sudo {
    package { sudo:
	ensure => installed;
    }

    file { "/etc/sudoers.d":
        ensure => directory,
        mode => 711,
        owner => root,
        group => root,
    }

    file { "/etc/sudoers":
	ensure => present,
	owner => root,
	group => root,
	mode => 440,
	content => template("sudo/sudoers")
    }

    define sudoers_config($content) {
	file { "/etc/sudoers.d/$name":
            owner => root,
            group => root,
            mode => 440,
            content => $content,
	}
    }
}
