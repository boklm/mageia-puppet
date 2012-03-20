define sudo::sudoers_config($content) {
    file { "/etc/sudoers.d/$name":
        mode    => '0440',
        content => $content,
    }
}
