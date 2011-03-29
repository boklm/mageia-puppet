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

        #TODO remove once libvirt package is fixed to manage the directory
        file { "/etc/libvirt/storage":
            ensure => directory,
        }

        file { "/etc/libvirt/storage/autostart":
            ensure => directory,
        }
        
        file { "/usr/local/bin/storage_add.py":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///libvirtd/storage_add.py", 
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
            mode => 644,
            ensure => present,
            content => template("libvirtd/50-template-libvirt-remote-access.pkla"),
        }
    }

    define storage($path, $autostart = true) {
        include libvirtd::base

        exec { "/usr/local/bin/storage_add.py $name $path":
            creates => "/etc/libvirt/storage/$name.xml",
            require => File['/usr/local/bin/storage_add.py'],
        }

        file { "/etc/libvirt/storage/autostart/$name.xml":
            ensure => $autostart ? {
                            true => "/etc/libvirt/storage/$name.xml",
                            false => "absent"
                      }
        }
    }
}
