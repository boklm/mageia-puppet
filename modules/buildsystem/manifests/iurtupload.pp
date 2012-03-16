class buildsystem::iurtupload {
    $login = $buildsystem::iurt::user::login
    $homedir = $buildsystem::iurt::user::homedir

    file { '/etc/iurt/upload.conf':
        require => File['/etc/iurt'],
        content => template('buildsystem/upload.conf')
    }
}


