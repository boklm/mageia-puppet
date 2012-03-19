class mirror::newrelease {
    include mirror::base
    mirrordir { 'newrelease':
        remoteurl => "rsync://rsync.$::domain/newrelease",
        localdir  => '/distrib/newrelease',
    }
}
