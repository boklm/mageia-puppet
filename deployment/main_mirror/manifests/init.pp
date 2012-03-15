class main_mirror {
    # FIXME shouldn't the various code in this module ?
    include mirror::main

    class { 'rsyncd':
        rsyncd_conf => 'main_mirror/rsyncd.conf'
    }

    $mirror = '/distrib'
    file { [$mirror,
            "$mirror/mirror",
            "$mirror/archive"]:
        ensure => directory,
    }

    file {
        "$mirror/README":               source => 'puppet:///modules/main_mirror/README';
        "$mirror/mirror/mirror.readme": source => 'puppet:///modules/main_mirror/mirror/mirror.readme';
        "$mirror/mirror/paths.readme":  source => 'puppet:///modules/main_mirror/mirror/paths.readme';
    }
}
