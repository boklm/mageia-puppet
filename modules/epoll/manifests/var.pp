# == Class: epoll::var
#
# epoll configuration
#
# === Parameters
#
# [*vhost*]
#   epoll vhost
#
# [*db_hostname*]
#   hostname of the database server
#
# [*db_name*]
#   name of the database
#
# [*db_user*]
#   user to connect to the database
#
# [*db_password*]
#   password to connect to the database
#
class epoll::var (
  $vhost       = "epoll.$::domain",
  $db_hostname = 'localhost',
  $db_name     = 'epoll',
  $db_user     = 'epoll',
  $db_password
) {
}
# vim: sw=2
