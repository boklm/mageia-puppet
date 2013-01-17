class postgresql::var(
  $pgsql_data = '/var/lib/pgsql/data/',
  $pg_version = '9.0'
)
{
  $hba_file = "${pgsql_data}/pg_hba.conf"
}
# vim: sw=2
