class buildsystem {
    class binrepo inherits base {
        include sudo
        $binrepo_login = "binrepo"
        $binrepo_homedir = "/var/lib/$binrepo_login"
        $binrepodir = "$binrepo_homedir/data"
        $uploadinfosdir = "$binrepo_homedir/infos"
        $uploadbinpath = '/usr/local/bin/upload-bin'
        $uploadmail_from = "root@$domain"
        $uploadmail_to = "packages-commits@ml.$domain"

        $packagers_committers_group = $buildsystem::base::packagers_committers_group

        user {"$binrepo_login":
            ensure => present,
            comment => "Binary files repository",
            managehome => true,
            shell => "/bin/bash",
            home => "$binrepo_homedir",
        }

        file { [$binrepodir, $uploadinfosdir]:
            ensure => directory,
            owner => $binrepo_login,
        }

        local_script {
            "upload-bin": content => template('buildsystem/binrepo/upload-bin');
            "wrapper.upload-bin": content => template('buildsystem/binrepo/wrapper.upload-bin');
        }

        sudo::sudoers_config { "binrepo":
            content => template("buildsystem/binrepo/sudoers.binrepo")
        }

        apache::vhost_base { "binrepo.$domain":
            location => $binrepodir,
            content => template("buildsystem/binrepo/vhost_binrepo.conf"),
        }
    }
}
