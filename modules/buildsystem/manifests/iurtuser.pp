class buildsystem::iurtuser {
    sshuser { $buildsystem::base::build_login:
        homedir => $buildsystem::base::build_home_dir,
        comment => 'System user used to run build bots',
    }

    file { '/etc/iurt':
        ensure => directory,
    }
}


