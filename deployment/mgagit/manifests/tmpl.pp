define mgagit::tmpl($tmpldir, $group = $title, $ml = $title) {
    file { "$tmpldir/${title}_repo.gl":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('mgagit/group_owned_repo.gl'),
    }
}
