define phpbb::redirection_instance($url) {
    $lang = $name
    file { "/etc/httpd/conf/vhosts.d/forums.d/redirect_$name.conf":
        content => template('phpbb/forums_redirect.conf'),
        notify  => Exec['service httpd configtest'],
    }
}
