class epoll::create_db () {
  postgresql::remote_db_and_user { $epoll::var::db_name:
    description => 'Epoll database',
    password    => $epoll::var::db_password,
  }
}
# vim: sw=2
