define postgresql::remote_user( $password,
                                $tag = 'default') {
    @@postgresql::user { $name:
        tag      => $tag,
        password => $password,
    }
}


