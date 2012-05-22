node rabbit {
# Location: Server offered by Dedibox (paris)
#
# - used to create isos ( and live, and so on )
#
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }
    include bcd::base
    include bcd::web
    include bcd::rsync
    include draklive
    include access_classes::iso_makers
    include openssh::ssh_keys_from_ldap
    include mirror::mageia
    include releasekey

    youri-check::config {'config_cauldron':
        version => 'cauldron',
    }
    youri-check::check {'check_cauldron':
        version => 'cauldron',
        hour    => '*',
        minute  => 4
    }

    youri-check::config {'config_1':
        version => '1',
    }
    youri-check::check {'check_1':
        version => '1',
        hour    => '*/2',
        minute  => 30
    }

    # for testing iso quickly
    include libvirtd::kvm
    libvirtd::group_access { 'mga-iso_makers': }

}
