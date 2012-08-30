class common::base_packages {
    # packages installed everywhere
    # asked by misc: screen, vim-enhanced, htop, lsof, tcpdump, less,
    #                 lvm2, lshw, iotop
    # asked by nanar: rsync
    # asked bu dams: watchdog, wget
    $package_list= ['screen',
                    'vim-enhanced',
                    'htop',
                    'lsof',
                    'tcpdump',
                    'rsync',
                    'less',
                    'lshw',
                    'lvm2',
                    'iotop',
		    'watchdog',
		    'wget']

    if $::arch == 'x86_64' {
        $package_list += ['mcelog']
    }

    package { $package_list: }

    # removed as it mess up with our policy for password
    # and is not really used
    package { 'msec':
        ensure => 'absent',
    }
}
