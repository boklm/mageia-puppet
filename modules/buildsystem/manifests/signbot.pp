class buildsystem::signbot {
    include buildsystem::var::scheduler
    include buildsystem::var::signbot
    $sched_login = $buildsystem::var::scheduler::login

    sshuser { $buildsystem::var::signbot::login:
        homedir => $buildsystem::var::signbot::home_dir,
        comment => 'System user used to sign packages',
        groups  => [$sched_login],
    }

    gnupg::keys{ 'packages':
        email    => $buildsystem::var::signbot::keyemail,
        key_name => $buildsystem::var::signbot::keyname,
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
