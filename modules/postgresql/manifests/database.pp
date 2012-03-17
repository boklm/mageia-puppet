# TODO convert it to a regular type ( so we can later change user and so on )
define postgresql::database($description = '',
                            $user = 'postgres',
                            $callback_notify = '') {

    exec { "createdb -O $user -U postgres $name '$description'":
        user    => 'root',
        unless  => "psql -A -t -U postgres -l | grep '^$name|'",
        require => Service['postgresql'],
    }

    # this is fetched by the manifest asking the database creation,
    # once the db have been created
    # FIXME proper ordering ?
    @@postgresql::database_callback { $name:
        tag             => $name,
        callback_notify => $callback_notify,
    }
}
