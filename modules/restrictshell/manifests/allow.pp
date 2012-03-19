define restrictshell::allow {
    include shell
    file { "/etc/membersh-conf.d/allow_$name.pl":
        mode    => '0755',
        content => "\$use_$name = 1;\n",
    }
}
