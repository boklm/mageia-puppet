class buildsystem::iurtupload {
    file { '/etc/iurt/upload.conf':
        require => File['/etc/iurt'],
        content => template('buildsystem/upload.conf')
    }
}


