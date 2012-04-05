define mirror_cleaner::orphans($base) {
    include mirror_cleaner::base

    $orphan_dir = '/distrib/archive/orphans'

    file { $orphan_dir:
        ensure => directory
    }

    cron { "clean orphans $name":
        command => "/usr/local/bin/orphans_cleaner.pl $base/$name $orphan_dir",
        hour    => 5,
        minute  => 30,
        user    => root,
    }

    tidy { $orphan_dir:
        type    => 'ctime',
        age     => '4w',
        recurse => true,
        matches => ['*.rpm'],
    }
}
