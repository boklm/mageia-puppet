class buildsystem::iurt {
    include sudo
    include buildsystem::iurt::user
    include buildsystem::iurt::packages
    include buildsystem::var::iurt

    ssh::auth::client { $buildsystem::var::iurt::login: }

    # remove old build directory
    tidy { "${buildsystem::var::iurt::homedir}/iurt":
        age     => '8w',
        recurse => true,
        matches => ['[0-9][0-9].*\..*\..*\.[0-9]*','log','*.rpm','*.log','*.mga[0-9]+'],
        rmdirs  => true,
    }

    file { '/etc/iurt/build':
        ensure => directory,
    }

    buildsystem::iurt::config { ['2','1','cauldron','mandriva2010.1','infra_1', 'infra_2']: }

    sudo::sudoers_config { 'iurt':
        content => template('buildsystem/iurt/sudoers.iurt')
    }
}
