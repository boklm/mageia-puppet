class sudo {
    package { sudo: }

    file { "/etc/sudoers.d":
        ensure => directory,
        mode => 711,
    }

    file { "/etc/sudoers":
        mode => 440,
        content => template("sudo/sudoers")
    }

    define sudoers_config($content) {
        file { "/etc/sudoers.d/$name":
            mode => 440,
            content => $content,
        }
    }
}
