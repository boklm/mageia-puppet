define postgresql::db_and_user( $password,
                                $description = '',
                                $callback_notify = '') {

    postgresql::database { $name:
        callback_notify => $callback_notify,
        description     => $description,
        user            => $name,
        require         => Postgresql::User[$name],
    }

    postgresql::user { $name:
        password => $password
    }
}
