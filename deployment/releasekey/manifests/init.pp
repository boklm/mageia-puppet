class releasekey {
    class variable {
	$sign_login = "releasekey"
	$sign_home_dir = "/var/lib/$sign_login"
	$sign_keydir = "$sign_home_dir/keys"
    }

    class base inherits variable {
	group {"$sign_login":
	    ensure => present,
	}

	user {"$sign_login":
	    ensure => present,
	    comment => "System user to sign Mageia Releases",
	    managehome => true,
	    home => $sign_home_dir,
	    gid => $sign_login,
	    shell => "/bin/bash",
	    require => Group[$sign_login],
	}

	gnupg::keys{"release":
	    email => "release@$domain",
	    #FIXME there should be a variable somewhere to change the name of the distribution
	    key_name => 'Mageia Release',
	    login => $sign_login,
	    batchdir => "$sign_home_dir/batches",
	    keydir => $sign_keydir,
	    require => Sshuser[$sign_login],
	}
    }
}
