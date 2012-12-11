class buildsystem::signbot {
    include buildsystem::scheduler::var
    include buildsystem::var::signbot
    $sched_login = $buildsystem::scheduler::var::login

    sshuser { $buildsystem::var::signbot::login:
        homedir => $buildsystem::var::signbot::home_dir,
        comment => 'System user used to sign packages',
        groups  => [$sched_login],
    }

    gnupg::keys{ 'packages':
        email    => "packages@$::domain",
        #FIXME there should be a variable somewhere to change
        # the name of the distribution
        key_name => 'Mageia Packages',
        login    => $buildsystem::var::signbot::login,
        batchdir => "${buildsystem::var::signbot::home_dir}/batches",
        keydir   => $buildsystem::var::signbot::sign_keydir,
    }

    sudo::sudoers_config { 'signpackage':
        content => template('buildsystem/signbot/sudoers.signpackage')
    }

    file { "$home_dir/.rpmmacros":
        source => 'puppet:///modules/buildsystem/signbot/signbot-rpmmacros',
    }

    mga-common::local_script {
        'sign-check-package': source => 'puppet:///modules/buildsystem/signbot/sign-check-package';
        'mga-signpackage':    source => 'puppet:///modules/buildsystem/signbot/mga-signpackage';
    }
}
