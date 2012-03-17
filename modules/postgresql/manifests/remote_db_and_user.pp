define postgresql::remote_db_and_user($password,
                                      $description = '',
                                      $tag = 'default',
                                      $callback_notify = '') {

    @@postgresql::db_and_user { $name:
        callback_notify => $callback_notify,
        tag             => $tag,
        description     => $description,
        password        => $password,
    }

    # fetch the exported ressources that should have been exported
    # once the db was created, and trigger a notify to the object
    # passed as callback_notify
    Postgresql::Database_callback <<| tag == $name |>>
}
