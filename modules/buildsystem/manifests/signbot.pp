class buildsystem::signbot {
    include buildsystem::scheduler::var
    $login = 'signbot'
    $home_dir = "/var/lib/$login"
    $sign_keydir = "$home_dir/keys"
    # FIXME: maybe keyid should be defined at an other place
    $keyid = '80420F66'
    $sched_login = $buildsystem::scheduler::var::login

    sshuser { $login:
        homedir => $home_dir,
        comment => 'System user used to sign packages',
        groups  => [$sched_login],
    }

    gnupg::keys{ 'packages':
        email    => "packages@$::domain",
        #FIXME there should be a variable somewhere to change
        # the name of the distribution
        key_name => 'Mageia Packages',
        login    => $login,
        batchdir => "$home_dir/batches",
        keydir   => $sign_keydir,
    }

    sudo::sudoers_config { 'signpackage':
        content => template('buildsystem/signbot/sudoers.signpackage')
    }

    file { "$home_dir/.rpmmacros":
        content => template('buildsystem/signbot/signbot-rpmmacros')
    }

    mga-common::local_script {
        'sign-check-package': content => template('buildsystem/signbot/sign-check-package');
        'mga-signpackage':    content => template('buildsystem/signbot/mga-signpackage');
    }
}
