# what should be possible :
# install a base system 
#   - mandriva
#   - mageia
#   - others ? ( for testing package ? )

# install a server 
#   - by name, with a valstart clone

class auto_installation {
    class pxe_menu {
        package { 'syslinux':

        }
        
        $pxe_dir = "/var/lib/pxe"
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

        # default file should have exported ressources
        file { "$pxe_dir/pxelinux.cfg/default":
            ensure => present,
            content => template('auto_installation/default'),
        } 
   
    }

    # define pxe_linux_entry 
        # meant to be exported
        #  name 
        #   label 
        #   kernel
        #   append

    # 
    # define a template for autoinst
    #  - basic installation
    #  - server installation ( with server name as a parameter )


    # TODO move here the downloader of boot.iso from libvirt module
}
