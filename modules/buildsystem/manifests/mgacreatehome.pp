class buildsystem {
    # temporary script to create home dir with ssh key
    # taking login and url as arguments
    class mgacreatehome {
	file { "/usr/local/sbin/mgacreatehome":
            ensure => present,
            owner => root,
            group => root,
            mode => 700,
            content => template("buildsystem/mgacreatehome")
	}
    }
}

