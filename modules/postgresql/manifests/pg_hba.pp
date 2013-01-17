define postgresql::pg_hba(
  $conf_lines = []
) {
  $db = list_exported_ressources('Postgresql::Db_and_user')

  $forum_lang = list_exported_ressources('Phpbb::Locale_db')

  postgresql::config { $name:
    content => template('postgresql/pg_hba.conf'),
  }
}
# vim: sw=2
