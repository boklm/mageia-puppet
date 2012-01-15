# svn, big important server
node valstar {
# Location: IELO datacenter (marseille)
#
# TODO:
# - GIT server
# - setup maintainers database (with web interface)
#
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include main_mirror
    include openldap::master 
    include subversion::client
    include subversion::server
    include puppet::master
    include reports::ii

    include ssh::auth
    include ssh::auth::keymaster
    include buildsystem::mainnode
    include buildsystem::mgacreatehome
    include buildsystem::sync20101
    include buildsystem::release
    include buildsystem::maintdb
    include buildsystem::binrepo
    include softwarekey::base

    include access_classes::committers
    include restrictshell::allow_git
    include restrictshell::allow_svn
    include restrictshell::allow_pkgsubmit
    include restrictshell::allow_maintdb
    include restrictshell::allow_upload_bin
    # disabled the ldap key here instead of disabling for the
    # whole module ( see r698 )
    class { "openssh::ssh_keys_from_ldap":
    	symlink_users => ['schedbot', 'iurt']
    }

    include mirror::mdv2010spring

    include repositories::subversion
    include repositories::git
    include repositories::sparkleshare

    include websites::svn

    subversion::snapshot { "/etc/puppet":
        source => "svn://svn.mageia.org/svn/adm/puppet/"
    }

    mirror_cleaner::orphans {  "cauldron":
        base => "/distrib/bootstrap/distrib/",
    }

}

# web apps
node alamut {
# Location: IELO datacenter (marseille)
#
# TODO:
# - Review board
# - api
# - wiki
# - pastebin
# - LDAP slave
# 
    include common::default_mageia_server_no_smtp
    include postgresql::server
    postgresql::tagged { "default": }

    timezone::timezone { "Europe/Paris": }

    include catdap
    include mga-mirrors
    include epoll
    include transifex
    include bugzilla
    include sympa::server
    include postfix::primary_smtp

    # temporary, just the time the vm is running there
    host { 'friteuse':
        ip => '192.168.122.131',
        host_aliases => [ "friteuse.$domain", "forums.$domain" ],
        ensure => 'present',
    }

    # to create all phpbb database on alamut
    phpbb::databases { $fqdn: }

    apache::vhost_redirect_ssl { "forums.$domain": }
    apache::vhost_redirect { "forum.$domain":
    	url => "https://forums.$domain/",
    }
    apache::vhost_redirect { "ssl_forum.$domain":
    	url => "https://forums.$domain/",
	vhost => "forum.$domain",
	use_ssl => true,
    }

    # connect to ssl so the proxy do not shoke if trying to 
    # enforce ssl ( note that this has not been tested, maybe this
    # is uneeded )
    apache::vhost_reverse_proxy { "ssl_forums.$domain":
        url => "https://forums.$domain/",
        vhost => "forums.$domain",
        use_ssl => true,
    }

    include tld_redirections

    include libvirtd::kvm
    include lists
    include dns::server 
    include repositories::svn_mirror
    include viewvc

    # disabled until fixed
    #include repositories::git_mirror
    include gitweb

    include xymon::server
    apache::vhost_simple { "xymon.$domain":
	location => "/var/lib/xymon/www",
    }
    include youri-check::report

    include wikis
}

# buildnode
node jonund {
# Location: IELO datacenter (marseille)
#
    include common::default_mageia_server
    include buildsystem::buildnode
    include buildsystem::iurt20101
    timezone::timezone { "Europe/Paris": }
    include shorewall
    include shorewall::default_firewall
}

node ecosse {
# Location: IELO datacenter (marseille)
#
    include common::default_mageia_server
    include buildsystem::buildnode
    timezone::timezone { "Europe/Paris": }
}

# backup server
node fiona {
# Location: IELO datacenter (marseille)
#
# TODO:
# - buy the server
# - install the server in datacenter
# - install a backup system
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
} 

# gandi-vm
node krampouezh {
# Location: gandi VM
#
#
    #include common::default_mageia_server
    include common::default_mageia_server_no_smtp
    include postfix::secondary_smtp
    include blog::base
    include blog::db_backup
    include mysql::server
    include dns::server 
    timezone::timezone { "Europe/Paris": }

    openldap::slave_instance { "1":
        rid => 1,
    }

# Other services running on this server :
# - meetbot
}

node champagne {
# Location: gandi VM
#
# TODO:
# - setup mageia.org web site
#
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include blog::files-bots
    include blog::files_backup
    include planet
    include websites::static
    include websites::hugs
    include websites::releases
    include websites::www
    include dashboard::base
    include access_classes::web
    include openssh::ssh_keys_from_ldap
}

node friteuse {
# Location: VM hosted by nfrance (toulouse)
# 

    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include forums
}

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
