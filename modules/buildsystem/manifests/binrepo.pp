class buildsystem::binrepo {
        include buildsystem::base
        include sudo
        $login = 'binrepo'
        $homedir = "/var/lib/$login"
        $repodir = "$homedir/data"

        $uploadinfosdir = "$homedir/infos"
        $uploadbinpath = '/usr/local/bin/upload-bin'
        $uploadmail_from = "root@$::domain"
        $uploadmail_to = "packages-commits@ml.$::domain"

        # used in templates
        $packagers_committers_group = $buildsystem::base::packagers_committers_group

        user { $login:
            comment => 'Binary files repository',
            home    => $homedir,
        }

        file { [$repodir, $uploadinfosdir]:
            ensure => directory,
            owner  => $login,
        }

        local_script {
            'upload-bin':
                content => template('buildsystem/binrepo/upload-bin');
            'wrapper.upload-bin':
                content => template('buildsystem/binrepo/wrapper.upload-bin');
        }

        sudo::sudoers_config { 'binrepo':
            content => template('buildsystem/binrepo/sudoers.binrepo')
        }

        apache::vhost_base { "binrepo.$::domain":
            location => $repodir,
            content  => template('buildsystem/binrepo/vhost_binrepo.conf'),
        }
    }
}
