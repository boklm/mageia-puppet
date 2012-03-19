class mirror::mageia {
    include mirrors::base
    mirrordir { 'mageia':
        remoteurl => "rsync://rsync.$::domain/mageia",
        localdir  => '/distrib/mageia',
    }
}
