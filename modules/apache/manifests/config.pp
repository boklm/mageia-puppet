define apache::config($content) {
    file { $name:
        content => $content,
        notify  => Exec['service httpd configtest'],
    }
}
