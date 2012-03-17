define postgresql::database_callback($callback_notify = '') {
    # dummy declaration, so we can trigger the notify
    if $callback_notify {
        exec { "callback $name":
            command => '/bin/true',
            notify  => $callback_notify,
        }
    }
}
