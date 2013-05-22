class buildsystem::iurt::user {
    include buildsystem::var::iurt

    buildsystem::sshuser { $buildsystem::var::iurt::login:
        homedir => $buildsystem::var::iurt::homedir,
        comment => 'System user used to run build bots',
    }

    file { '/etc/iurt':
        ensure => directory,
    }
}
