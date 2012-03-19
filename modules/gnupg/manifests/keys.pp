    # debian recommend SHA2, with 4096
    # http://wiki.debian.org/Keysigning
    # as they are heavy users of gpg, I will tend
    # to follow them
    # however, for testing purpose, 4096 is too strong,
    # this empty the entropy of my vm
class gnupg::keys($email,
                  $key_name,
                  $key_type = 'RSA',
                  $key_length = '4096',
                  $expire_date = '400d',
                  $login = 'signbot',
                  $batchdir = '/var/lib/signbot/batches',
                  $keydir = '/var/lib/signbot/keys') {

    include gnupg::client
    file { "$name.batch":
        path    => "$batchdir/$name.batch",
        content => template('gnupg/batch')
    }

    file { $keydir:
        ensure => directory,
        owner  => $login,
        mode   => '0700',
    }

    file { $batchdir:
        ensure => directory,
        owner  => $login,
    }

    exec { "/usr/local/bin/create_gnupg_keys.sh $batchdir/$name.batch $keydir $batchdir/$name.done":
        user    => $login,
        creates => "$batchdir/$name.done",
        require => [File[$keydir], File["$batchdir/$name.batch"], Package['rng-utils']],
    }
}
