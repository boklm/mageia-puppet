define apache::config($content) {
    file { $name:
        content => $content,
        require => Package['apache-conf'],
        notify  => Exec['service httpd configtest'],
    }
}
