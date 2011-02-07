class gnupg {
    class client {
        package { ["gnupg","rng-utils"]:
            ensure => present,
        }
        
        file { "/usr/local/bin/create_gnupg_keys.sh":
             ensure => present,
             owner => root,
             group => root,
             mode => 755,
             content => template('gnupg/create_gnupg_keys.sh')
        }
    }

    # debian recommend SHA2, with 4096
    # http://wiki.debian.org/Keysigning
    # as they are heavy users of gpg, I will tend 
    # to follow them
    # however, for testing purpose, 4096 is too strong, 
    # this empty the entropy of my vm
    define keys( $email,
                 $key_name,
                 $key_type = 'RSA',
                 $key_length = '1024',
                 $expire_date = '1m',
		 $login = 'signbot',
		 $batchdir = '/var/lib/signbot/batches',
		 $keydir = '/var/lib/signbot/keys'
                 ) {

            include gnupg::client
            file { "$name.batch":
                ensure => present,
                path => "$batchdir/$name.batch",
                content => template("gnupg/batch")
            }

	    file { "$keydir":
	    	ensure => directory,
		owner => $login,
		mode => 700,
	    }

	    file { "$batchdir":
	    	ensure => directory,
		owner => $login,
	    }

            exec { "/usr/local/bin/create_gnupg_keys.sh $batchdir/$name.batch $keydir $batchdir/$name.done":
                 user => $login,
                 creates => "$batchdir/$name.done",
                 require => [File["$keydir"], File["$batchdir/$name.batch"], Package["rng-utils"]],
            }
    }
}
