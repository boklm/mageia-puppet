class openssl {
    class base {
        package { 'openssl':
            ensure => installed
        }
    } 

	define self_signed_cert($directory = '/etc/certs') {
        include openssl::base
        
        $pem_file = "$name.pem"
	    exec { "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $pem_file -out $pem_file -subj  '/CN=$name.$domain'":
            cwd => "$directory",
            creates => "$directory/$name.pem",
            require => Package['openssl']
        }
	}
}
