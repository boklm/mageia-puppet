class common::urpmi_update {
    cron { 'urpmi_update':
        user    => 'root',
        hour    => '*/4',
        minute  => 0,
        command => '/usr/sbin/urpmi.update -a -q',
    }
}
