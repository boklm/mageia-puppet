class sudo {
    package { sudo:
	ensure => installed;
    }

    file { "/etc/sudoers.d":
        ensure => directory,
        mode => 700,
        owner => root,
        group => root,
    }

    file { "/etc/sudoers":
	ensure => present,
	owner => root,
	group => root,
	mode => 600,
	content => template("sudo/sudoers")
    }
}
