class subversion::client {
    # svn spam log with
    # Oct 26 13:30:01 valstar svn: No worthy mechs found
    # without it,
    # http://mail-index.netbsd.org/pkgsrc-users/2008/11/23/msg008706.html
    #
    $sasl2_package = $::architecture ? {
        x86_64  => 'lib64sasl2-plug-anonymous',
        default => 'libsasl2-plug-anonymous'
    }

    package { ['subversion', $sasl2_package]: }
}
