class releasekey {
    $sign_login = 'releasekey'
    $sign_home_dir = "/var/lib/$sign_login"
    $sign_keydir = "$sign_home_dir/keys"
    group { $sign_login: }

    user { $sign_login:
        comment => 'System user to sign Mageia Releases',
        home    => $sign_home_dir,
        gid     => $sign_login,
        require => Group[$sign_login],
    }

    gnupg::keys{ 'release':
        email    => "release@$::domain",
        #FIXME there should be a variable somewhere to change the name of the distribution
        key_name => 'Mageia Release',
        login    => $sign_login,
        batchdir => "$sign_home_dir/batches",
        keydir   => $sign_keydir,
        require  => User[$sign_login],
    }

    mga_common::local_script { 'sign_checksums':
        content => template('releasekey/sign_checksums'),
    }
}
