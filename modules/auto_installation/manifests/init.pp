# what should be possible :
# install a base system 
#   - mandriva
#   - mageia
#   - others ? ( for testing package ? )

# install a server 
#   - by name, with a valstart clone

class auto_installation {
    class variables {
        $pxe_dir = "/var/lib/pxe"
        # m/  for menu. There is limitation on the path length so
        # while we will likely not hit the limit, it may be easier
        $pxe_menu_dir = "$pxe_dir/pxelinux.cfg/m/"
    }

    class download { 
        import "download.rb"
    }

    class pxe_menu inherits variables {
        package { 'syslinux':

        }
        
        file { $pxe_dir:
            ensure => directory,
        }

        file { "$pxe_dir/pxelinux.0":
            ensure => "/usr/lib/syslinux/pxelinux.0",
        }
       
        file { "$pxe_dir/menu.c32":
            ensure => "/usr/lib/syslinux/menu.c32"
        }
        
        file { "$pxe_dir/pxelinux.cfg":
            ensure => directory,
        }
        # m for menu, there is some limitation on the path lenght so I 
        # prefer to 
        file { "$pxe_menu_dir":
            ensure => directory,
        }

        # TODO make it tag aware
        $menu_entries = list_exported_ressources('Auto_installation::Pxe_menu_base')
        # default file should have exported ressources
        file { "$pxe_dir/pxelinux.cfg/default":
            ensure => present,
            content => template('auto_installation/default'),
        }
        Auto_installation::Pxe_menu_base <<| tag == $fqdn |>> 
    }

    define pxe_menu_base($content) {
        include auto_installation::variables
        file { "$auto_installation::variables::pxe_menu_dir/$name":
            ensure => present,
            content => $content,
        }
    }

    define pxe_menu_entry($kernel_path, $append, $label) {
        @@auto_installation::pxe_menu_base { $name: 
            tag => $fqdn,   
            content => template('auto_installation/menu'),
        }
    }

    # define pxe_linux_entry 
        # meant to be exported
        #  name 
        #   label 
        #   kernel
        #   append
    class netinst_storage {
        # to ease the creation of test iso 
        $netinst_path = "/var/lib/libvirt/netinst"

        file { $netinst_path:
            ensure => directory,
        }

        libvirtd::storage { "netinst":
            path => $netinst_path,
            require => File[$netinst_path],
        }
    }

    define download_file($destination_path, $download_url) {
            exec { "wget -q -O $destination_path/$name $download_url/$name":
                creates =>  "$destination_path/$name",
            }
    }

    define mandriva_installation_entry($version, $arch = 'x86_64') {
        include netinst_storage
        $protocol = "ftp"
        $server = "ftp.free.fr"
        $mirror_url_base = "/pub/Distributions_Linux/MandrivaLinux/"
        $mirror_url_middle =  $version ? {
            "cooker" => "devel/cooker/$arch/",
            default => "official/$version/$arch/"
        }
        $mirror_url = "$mirror_url_base/$mirror_url_middle"

        $mirror_url_end = "isolinux/alt0"

        $destination_path = "$netinst_storage::netinst_path/$name"

        file { "$destination_path":
            ensure => directory,
        }

        $download_url = "$protocol\://$server/$mirror_url/$mirror_url_end"
        

        download_file { ['all.rdz','vmlinuz']:
            destination_path => $destination_path,
            download_url => $download_url,
            require => File[$destination_path], 
        }

        pxe_menu_entry { "mandriva_$version_$arch":
            kernel_path => "$name/vmlinuz",
            label => "Mandriva $version $arch",
            #TODO add autoinst.cfg
            append => "$name/all.rdz  useless_thing_accepted=1 lang=fr automatic=int:eth0,netw:dhcp,met:$protocol,ser:$server,dir:$mirror_url ",
        } 
    }
    # 
    # define a template for autoinst
    #  - basic installation
    #  - server installation ( with server name as a parameter )

}
