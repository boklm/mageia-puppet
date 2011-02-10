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
}
