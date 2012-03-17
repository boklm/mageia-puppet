define postgresql::config($content) {
    file { $name:
        owner   => 'postgres',
        group   => 'postgres',
        mode    => '0600',
        content => $content,
        require => Package['postgresql-server'],
        notify  => Exec['service postgresql reload'],
    }
}
