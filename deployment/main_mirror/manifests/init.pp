class main_mirror {
    # FIXME shouldn't the various code in this module ?
    include mirror::main

    $mirror = "/distrib"
    file { "$mirror":
        ensure => directory,
    }

    file { "$mirror/README":
        ensure => present,
        source => "puppet:///modules/main_mirror/README"         
    }

    file { "$mirror/mirror":
        ensure => directory,

    }

    file { "$mirror/mirror/mirror.readme":
        ensure => present,
        source => "puppet:///modules/main_mirror/mirror/mirror.readme"         
    }

    file { "$mirror/mirror/paths.readme":
        ensure => present,
        source => "puppet:///modules/main_mirror/mirror/paths.readme"         
    }


}
