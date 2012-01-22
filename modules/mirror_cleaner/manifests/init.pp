class mirror_cleaner {
    class base {
        file { "/usr/local/bin/orphans_cleaner.pl":
             mode => 755,
             source => 'puppet:///modules/mirror_cleaner/orphans_cleaner.pl',
        }
    }

    define orphans($base) {
        include mirror_cleaner::base

        $orphan_dir = "/distrib/archive/orphans"

        file { $orphan_dir:
            ensure => directory
        }

        cron { "clean orphans $name":
            command => "/usr/local/bin/orphans_cleaner.pl $base/$name $orphan_dir",
            hour => 5,
            minute => 30,
            user => root,
        }

        tidy { $orphan_dir:
            age => "4w",
            recurse => true,
            matches => ["*.rpm"],
        }
    }
}
