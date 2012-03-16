class buildsystem::iurt::user {
    $login = 'iurt'
    $homedir = "/home/$login"

    sshuser { $login:
        homedir => $homedir,
        comment => 'System user used to run build bots',
    }

    file { '/etc/iurt':
        ensure => directory,
    }
}
