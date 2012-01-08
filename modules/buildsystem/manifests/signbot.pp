class buildsystem {
    class signbot {
        $login = "signbot"
        $sign_home_dir = "/var/lib/$login"
        $sign_keydir = "$sign_home_dir/keys"
	    # FIXME: maybe keyid should be defined at an other place
	    $keyid = "80420F66"
        # FIXME refactor with base class ( once variables are placed in a separate module )
        $sched_login = "schedbot"
	
        sshuser { $login:
            homedir => $sign_home_dir,
            comment => "System user used to sign packages",
	        groups => [$sched_login],
        }

    	gnupg::keys{"packages":
            email => "packages@$domain",
	        #FIXME there should be a variable somewhere to change the name of the distribution
  	        key_name => 'Mageia Packages',
	        login => $login,
	        batchdir => "$sign_home_dir/batches",
	        keydir => $sign_keydir,
        }

	    sudo::sudoers_config { "signpackage":
            content => template("buildsystem/signbot/sudoers.signpackage")
        }

        file { "$sign_home_dir/.rpmmacros":
	        content => template("buildsystem/signbot/signbot-rpmmacros")
	    }

        local_script { "sign-check-package":
            content => template("buildsystem/signbot/sign-check-package")
        }

        local_script { "mga-signpackage":
            content => template("buildsystem/signbot/mga-signpackage")
        }
    }
}
