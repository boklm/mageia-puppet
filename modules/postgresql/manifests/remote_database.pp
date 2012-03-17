define postgresql::remote_database($description = '',
                                   $user = 'postgresql',
                                   $callback_notify = '',
                                   $tag = 'default') {
    @@postgresql::database { $name:
        description     => $description,
        user            => $user,
        callback_notify => $callback_notify,
        tag             => $tag,
        require         => Postgresql::User[$user],
    }

    Postgresql::Database_callback <<| tag == $name |>>
}
