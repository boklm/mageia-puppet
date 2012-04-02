class openssh::pubkeys_directory {
    $pubkeys_directory = '/var/lib/pubkeys'
    file { $pubkeys_directory:
        ensure => directory,
    }

    file { "$pubkeys_directory/root":
        ensure => directory,
        mode   => '0700',
    }

    file { "$pubkeys_directory/root/authorized_keys":
        ensure => link,
        target => '/root/.ssh/authorized_keys',
        mode   => '0700',
    }
}
