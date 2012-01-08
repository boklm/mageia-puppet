class buildsystem {
    class signbot {
        $sign_login = "signbot"
        $sign_home_dir = "/var/lib/$sign_login"
        $sign_keydir = "$sign_home_dir/keys"
	    # FIXME: maybe keyid should be defined at an other place
	    $sign_keyid = "80420F66"
        # FIXME refactor with base class ( once variables are placed in a separate module )
        $sched_login = "schedbot"
	
        sshuser { $sign_login:
            homedir => $sign_home_dir,
            comment => "System user used to sign packages",
	        groups => [$sched_login],
        }

    	gnupg::keys{"packages":
            email => "packages@$domain",
	        #FIXME there should be a variable somewhere to change the name of the distribution
  	        key_name => 'Mageia Packages',
	        login => $sign_login,
	        batchdir => "$sign_home_dir/batches",
	        keydir => $sign_keydir,
        }

	    sudo::sudoers_config { "signpackage":
            content => template("buildsystem/signbot/sudoers.signpackage")
        }

        file { "$sign_home_dir/.rpmmacros":
	        mode => 644,
	        content => template("buildsystem/signbot/signbot-rpmmacros")
	    }

        file { "/usr/local/bin/sign-check-package":
            mode => 755,
            content => template("buildsystem/signbot/sign-check-package")
        }
    }
}
