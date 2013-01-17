class postgresql::pg_hba(
  $conf_lines = []
) {
  $db = list_exported_ressources('Postgresql::Db_and_user')

  $forum_lang = list_exported_ressources('Phpbb::Locale_db')

  postgresql::config { "${postgresql::server::pgsql_data}/pg_hba.conf":
    content => template('postgresql/pg_hba.conf'),
  }
}
# vim: sw=2
