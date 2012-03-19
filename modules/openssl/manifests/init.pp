class openssl {
    class base {
        package { 'openssl': }
    }

    define self_signed_cert($directory = '/etc/certs') {
        include openssl::base

        $pem_file = "$name.pem"
        exec { "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $pem_file -out $pem_file -subj  '/CN=$name'":
            cwd     => $directory,
            creates => "$directory/$name.pem",
            require => Package['openssl']
        }
    }

    define self_signed_splitted_cert( $filename = '',
                                      $directory = '/etc/certs',
                                      $owner = 'root',
                                      $group = 'root',
                                      $mode = '0600') {
        include openssl::base

        $crt_file = "$filename.crt"
        $key_file = "$filename.key"
        exec { "openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $key_file -out $crt_file -subj  '/CN=$name'":
            cwd     => $directory,
            creates => "$directory/$key_file",
            require => Package['openssl'],
            before  => [File["$directory/$key_file"],
                        File["$directory/$crt_file"]]
        }

        file { ["$directory/$key_file","$directory/$crt_file"]:
            owner => $owner,
            group => $group,
            mode  => $mode,
        }
    }
}
