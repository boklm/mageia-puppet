define postgresql::tagged() {
    # TODO add a system of tag so we can declare database on more than one
    # server
    Postgresql::User <<| tag == $name |>>
    Postgresql::Database <<| tag == $name |>>
    Postgresql::Db_and_user <<| tag == $name |>>
}
