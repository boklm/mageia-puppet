class iurt {

    # build node common settings
    # we could have the following skip list to use less space:
    # '/(drakx-installer-binaries|drakx-installer-advertising|gfxboot|drakx-installer-stage2|mandriva-theme)/'
    $package_list = ['task-bs-cluster-chroot', 'iurt']
    package { $package_list:
        ensure => installed;
    }

    file { '/home/buildbot/.iurt.cauldron.conf':
        ensure => present,
        owner => buildbot,
        group => buildbot,
        mode => 644,
        content => template("iurt/iurt.cauldron.conf")
    }

}

