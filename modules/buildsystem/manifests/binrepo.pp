class buildsystem::binrepo {
    include buildsystem::var::binrepo
    include buildsystem::var::groups
    include sudo

    user { $buildsystem::var::binrepo::login:
        comment => 'Binary files repository',
        home    => $buildsystem::var::binrepo::homedir,
    }

    file { [$buildsystem::var::binrepo::repodir, $buildsystem::var::binrepo::uploadinfosdir]:
        ensure => directory,
        owner  => $buildsystem::var::binrepo::login,
    }

    mga-common::local_script {
        'upload-bin':
            content => template('buildsystem/binrepo/upload-bin');
        'wrapper.upload-bin':
            content => template('buildsystem/binrepo/wrapper.upload-bin');
    }

    sudo::sudoers_config { 'binrepo':
        content => template('buildsystem/binrepo/sudoers.binrepo')
    }

    apache::vhost::base { "binrepo.${::domain}":
        location => $buildsystem::var::binrepo::repodir,
        content  => template('buildsystem/binrepo/vhost_binrepo.conf'),
    }
}
