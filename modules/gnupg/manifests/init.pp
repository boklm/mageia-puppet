class gnupg {
    class client {
        package { ["gnupg","rng-utils"]:
            ensure => present,
        }
        
        file { ["/etc/gnupg", "/etc/gnupg/batches"]:
            ensure => directory,
        }

        file { "/etc/gnupg/keys":
            ensure => directory,
            mode => 600,
            owner => root,
            group => root
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
                 $expire_date = '1m'
                 ) {

            include gnupg::client
            file { "$name.batch":
                ensure => present,
                path => "/etc/gnupg/batches/$name.batch",
                content => template("gnupg/batch")
            }

            # TODO make sure the perm are good  
            exec { "/usr/local/bin/create_gnupg_keys.sh $name":
                 user => root,
                 creates => "/etc/gnupg/keys/$name.secring",
                 require => File["/etc/gnupg/batches/$name.batch"]
            }
    }
}
