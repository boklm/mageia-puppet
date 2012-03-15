class common {
    class default_mageia_server_no_smtp {

        include shadow
        include openssh::server
        include common::default_ssh_root_key
        include common::base_packages
        include common::export_ssh_keys
        include common::import_ssh_keys
        include common::i18n
        include ntp
        include common::urpmi_update
        include puppet::client
        include xymon::client
        include cron

        # provided by lsb-core, but it also pull
        # various unneeded stuff for our server
        file { '/srv/':
            ensure => directory
        }
    }

    class default_mageia_server inherits default_mageia_server_no_smtp {
        include postfix::simple_relay
    }
}
