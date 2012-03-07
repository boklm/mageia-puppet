class mirror_cleaner::base {
    file { '/usr/local/bin/orphans_cleaner.pl':
        mode   => '0755',
        source => 'puppet:///modules/mirror_cleaner/orphans_cleaner.pl',
    }
}
