# For main Mageia mirror
class mirror::main {
    include mirror::base
    mga-common::local_script { 'update_timestamp':
        content => template('mirror/update_timestamp')
    }

    cron { 'mirror':
        user    => 'mirror',
        minute  => '*/10',
        command => '/usr/local/bin/update_timestamp',
        require => [Local_script['update_timestamp'], User['mirror']],
    }
}
