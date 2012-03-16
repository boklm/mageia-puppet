class buildsystem::iurt::user {
    $login = 'iurt'
    $homedir = "/home/$login"

    buildsystem::sshuser { $login:
        homedir => $homedir,
        comment => 'System user used to run build bots',
    }

    file { '/etc/iurt':
        ensure => directory,
    }
}
