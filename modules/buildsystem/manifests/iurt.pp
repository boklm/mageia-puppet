class buildsystem::iurt {
    include sudo
    include buildsystem::iurt::user
    include buildsystem::iurt::packages
    include buildsystem::var::iurt
    include buildsystem::var::distros

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

    $distros_list = hash_keys($buildsystem::var::distros::distros)
    buildsystem::iurt::config { $distros_list: }

    sudo::sudoers_config { 'iurt':
        content => template('buildsystem/sudoers.iurt')
    }
}
