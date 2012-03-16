class buildsystem::iurt::upload {
    $login = $buildsystem::iurt::user::login
    $homedir = $buildsystem::iurt::user::homedir
    $sched_login = $buildsystem::scheduler::login

    file { '/etc/iurt/upload.conf':
        require => File['/etc/iurt'],
        content => template('buildsystem/upload.conf'),
        notify  => Exec['check iurt config'],
    }

    exec { 'check iurt config':
        refreshonly => true,
        command     => 'perl -cw /etc/iurt/upload.conf',
        logoutput   => 'on_failure',
    }
}
