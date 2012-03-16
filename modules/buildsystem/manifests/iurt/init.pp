class buildsystem::iurt {
    include sudo
    include buildsystem::iurt::user
    include buildsystem::iurt::package
    $login = $buildsystem::iurt::user::login
    $homedir = $buildsystem::iurt::user::homedir

    ssh::auth::client { $login: }

    ssh::auth::server { $buildsystem::base::sched_login:
                        user => $login
    }

    # remove old build directory
    tidy { "$homedir/iurt":
        age     => '8w',
        recurse => true,
        matches => ['[0-9][0-9].*\..*\..*\.[0-9]*','log','*.rpm','*.log','*.mga[0-9]+'],
        rmdirs  => true,
    }

    file { '/etc/iurt/build':
        ensure => directory,
    }

   buildsystem::iurt::config { ['1','cauldron','mandriva2010.1','infra_1']: }

    sudo::sudoers_config { 'iurt':
        content => template('buildsystem/iurt/sudoers.iurt')
    }
}
