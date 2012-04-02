class softwarekey {
    $sign_login = 'softwarekey'
    $sign_home_dir = "/var/lib/$sign_login"
    $sign_keydir = "$sign_home_dir/keys"

    group { $sign_login: }

    user { $sign_login:
        comment => 'System user to sign Mageia Software',
        home    => $sign_home_dir,
        gid     => $sign_login,
        require => Group[$sign_login],
    }

    gnupg::keys{ 'software':
        email    => "software@$::domain",
        #FIXME there should be a variable somewhere to change the
        # name of the distribution
        key_name => 'Mageia Software',
        login    => $sign_login,
        batchdir => "$sign_home_dir/batches",
        keydir   => $sign_keydir,
        require  => User[$sign_login],
    }
}
