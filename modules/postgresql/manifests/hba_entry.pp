# == Define: postgresql::hba_entry
# 
# Set a new entry to pg_hba.conf file
#
# === Parameters
#
# See pgsql doc for more details about pg_hba.conf parameters :
# http://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html
#
# [*namevar*]
#   namevar is not used.
#
# [*type*]
#   can be local, host, hostssl, hostnossl
#
# [*database*]
#   database name
#
# [*user*]
#   user name
#
# [*address*]
#   host name or IP address range
#
# [*method*]
#   authentication method to use
#
define postgresql::hba_entry(
  $type,
  $database,
  $user,
  $address,
  $method
) {
  include postgresql::var
  Postgresql::Pg_hba <| title == $postgresql::var::hba_file |> {
    conf_lines +> "${type} ${database} ${user} ${address} ${method}",
  }
}
# vim: sw=2
