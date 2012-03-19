class mirror::mageia {
    include mirror::base
    mirrordir { 'mageia':
        remoteurl => "rsync://rsync.$::domain/mageia",
        localdir  => '/distrib/mageia',
    }
}
