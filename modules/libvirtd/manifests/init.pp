class libvirtd {
    class base {
        # make sure to use a recent enough version
        # dnsmasq-base -> for nat network
        # netcat-openbsd -> for ssh remote access
        # iptables -> for dhcp, message error was quite puzzling
        # python-* => needed for helper script
        package {['libvirt-utils',
                  'dnsmasq-base',
                  'netcat-openbsd',
                  'iptables',
                  'python-libvirt',
                  'python-IPy']:

        }

        service { 'libvirtd':
            require => Package['libvirt-utils'],
        }

        #TODO remove once libvirt package is fixed to manage the directory
        file { ['/etc/libvirt/storage',
                '/etc/libvirt/storage/autostart']:
            ensure  => directory,
            require => Package['libvirt-utils'],
        }

        file { '/usr/local/bin/storage_add.py':
            mode   => '0755',
            source => 'puppet:///modules/libvirtd/storage_add.py',
        }

        file { '/usr/local/bin/network_add.py':
            mode   => '0755',
            source => 'puppet:///modules/libvirtd/network_add.py',
        }

    }

    class kvm inherits base {
        # pull cyrus-sasl, should be checked
        package { 'qemu': }

    }

    # see http://wiki.libvirt.org/page/SSHPolicyKitSetup
    define group_access() {
        # to pull polkit and create the directory
        include libvirtd::base
        file { "/etc/polkit-1/localauthority/50-local.d/50-$name-libvirt-remote-access.pkla":
            content => template('libvirtd/50-template-libvirt-remote-access.pkla'),
            require => Package['libvirt-utils'],
        }
    }

    define storage($path, $autostart = true) {
        include libvirtd::base

        exec { "/usr/local/bin/storage_add.py $name $path":
            creates => "/etc/libvirt/storage/$name.xml",
            require => [File['/usr/local/bin/storage_add.py'],
                        Package['python-libvirt'] ]
        }

        #TODO use API of libvirt
        file { "/etc/libvirt/storage/autostart/$name.xml":
            ensure => $autostart ? {
                            true  => "/etc/libvirt/storage/$name.xml",
                            false => absent
                      },
            require => Package['libvirt-utils'],
        }
    }

    define network( $bridge_name = 'virbr0',
                    $forward = 'nat',
                    $forward_dev = 'eth0',
                    $network = '192.168.122.0/24',
                    $tftp_root = '',
                    $disable_pxe = '',
                    $autostart = true,
                    $vm_type = 'qemu') {

        exec { '/usr/local/bin/network_add.py':
            environment => ["BRIDGE_NAME=$bridge_name",
                            "FORWARD=$forward",
                            "FORWARD_DEV=$forward_dev",
                            "NETWORK=$network",
                            "TFTP_ROOT=$tftp_root",
                            "DISABLE_PXE=\"$disable_pxe\""],

            creates => "/etc/libvirt/$vm_type/networks/$name.xml",
            require => [File['/usr/local/bin/network_add.py'],
                        Package['python-IPy'], Package["python-libvirt"] ]
        }

        #TODO use API of libvirt
        file { "/etc/libvirt/$vm_type/networks/autostart/$name.xml":
            ensure => $autostart ? {
                            true  => "/etc/libvirt/$vm_type/networks/$name.xml",
                            false => absent
                      },
            require => Package['libvirt-utils'],
        }
    }
}
