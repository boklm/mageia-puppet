class libvirtd {
    class base {
        # make sure to use a recent enough version
        # dnsmasq-base -> for nat network
        # netcat-openbsd -> for ssh remote access
        # iptables -> for dhcp, message error was quite puzzling
        package { ["libvirt-utils","dnsmasq-base","netcat-openbsd","iptables"]:
        }

        service { libvirtd:
            ensure => running,
            path => "/etc/init.d/libvirtd",
        }
    }

    class kvm inherits base {
        # pull cyrus-sasl, should be checked
        package { "qemu":

        }
    
    }

    # see http://wiki.libvirt.org/page/SSHPolicyKitSetup
    define group_access() {
        # to pull polkit and create the directory
        include libvirtd::base
        file { "/etc/polkit-1/localauthority/50-local.d/50-$name-libvirt-remote-access.pkla":
            owner => root,
            group => root,
            perms => 644,
            ensure => present,
            content => template("libvirtd/50-template-libvirt-remote-access.pkla"),
        }
    }
}
