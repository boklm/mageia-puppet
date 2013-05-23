class buildsystem::iurt::upload {
    include buildsystem::var::iurt
    include buildsystem::var::webstatus
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
