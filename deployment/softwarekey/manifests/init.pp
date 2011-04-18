class softwarekey {
    class variable {
	$sign_login = "softwarekey"
	$sign_home_dir = "/var/lib/$sign_login"
	$sign_keydir = "$sign_home_dir/keys"
    }

    class base inherits variable {
	group {"$sign_login":
	    ensure => present,
	}

	user {"$sign_login":
	    ensure => present,
	    comment => "System user to sign Mageia Software",
	    managehome => true,
	    home => $sign_home_dir,
	    gid => $sign_login,
	    shell => "/bin/bash",
	    require => Group[$sign_login],
	}

	gnupg::keys{"software":
	    email => "software@$domain",
	    #FIXME there should be a variable somewhere to change the name of the distribution
	    key_name => 'Mageia Software',
	    login => $sign_login,
	    batchdir => "$sign_home_dir/batches",
	    keydir => $sign_keydir,
	    require => User[$sign_login],
	}
    }
}
