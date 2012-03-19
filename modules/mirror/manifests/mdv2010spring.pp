class mirror::mdv2010spring {
    include mirror::base
    mirrordir { 'mdv2010.1':
        remoteurl => 'rsync://distrib-coffee.ipsl.jussieu.fr/pub/linux/MandrivaLinux/official/2010.1',
        localdir  => '/distrib/mandriva/',
    }
}
