node rabbit {
# Location: Server offered by Dedibox (paris)
# 
# - used to create isos ( and live, and so on )
# 
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include bcd::base
    include bcd::web
    include bcd::rsync
    include draklive::base
    include access_classes::iso_makers
    include openssh::ssh_keys_from_ldap
    include mirror::mageia
    include mirror::newrelease
    include releasekey::base
    include youri-check::check

    # for testing iso quickly
    include libvirtd::kvm
    libvirtd::group_access { "mga-iso_makers": }

    # to ease the creation of test iso 
    $netinst_iso_path = "/var/lib/libvirt/netboot"

    file { $netinst_iso_path:
        ensure => directory,
    }

    libvirtd::storage { "netinst_iso":
        path => $netinst_iso_path,
        require => File[$netinst_iso_path],
    }

    include auto_installation::download
    auto_installation::download::netboot_images { "mandriva":
        path => $netinst_iso_path,
        versions => ["2010.0","2010.1"],
        archs => ['i586','x86_64'],
        mirror_path => "ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/%{version}/%{arch}/install/images/",
        files => ['boot.iso'],
        require => File[$netinst_iso_path],
    }

    # for testing pxe support of libvirt
    include auto_installation::variables
    libvirtd::network {"pxe_network":
        network => "192.168.123.0/24",
        tftp_root => $auto_installation::variables::pxe_dir,
        bridge_name => "virbr1",
    }

    include auto_installation::pxe_menu
    auto_installation::mandriva_installation_entry { "pxe_test":
        version => "2010.1",
        arch => "i586",
    }
}
