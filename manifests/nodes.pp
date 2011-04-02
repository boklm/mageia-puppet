# to not repeat the setting everywhere
Exec { path => "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin/" }

# svn, big important server
node valstar {
# Location: IELO datacenter (marseille)
#
# TODO:
# - GIT server
# - setup youri
# - setup maintainers database (with web interface)
# - mirroring (Nanar)
#
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include rsyncd
    include main_mirror
    include openldap::master 
    include subversion::client
    include subversion::server
    include puppet::master
    include ssh::auth
    include ssh::auth::keymaster
    include buildsystem::mainnode
    include buildsystem::mgacreatehome

    include access_classes::committers
    include restrictshell::allow_git
    include restrictshell::allow_svn
    include restrictshell::allow_pkgsubmit
    # disabled the ldap key here instead of disabling for the
    # whole module ( see r698 )
    #include openssh::ssh_keys_from_ldap

    include mirror::mirrormdv2010spring

    include repositories::subversion
    include repositories::git

    include websites::svn

    subversion::snapshot { "/etc/puppet":
        source => "svn://svn.mageia.org/svn/adm/puppet/"
    }
}

# web apps
node alamut {
# Location: IELO datacenter (marseille)
#
# TODO:
# - Review board
# - nagios
# - api
# - mail server
# - mailing list server
# - wiki
# - pastebin
# - LDAP slave
# 
    include common::default_mageia_server_no_smtp
    include postgresql::server
    timezone::timezone { "Europe/Paris": }

    include catdap
    include websites::donate
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


    include libvirtd::kvm
    include lists
    include dns::server 
    include repositories::mirror
    include viewvc
    include xymon::server
    apache::vhost_simple { "xymon.$domain":
	location => "/var/lib/xymon/www",
    }
    include youri-check::report
}

# buildnode
node jonund {
# Location: IELO datacenter (marseille)
#
    include common::default_mageia_server
    include buildsystem::buildnode
    timezone::timezone { "Europe/Paris": }
    include shorewall
    include shorewall::default_firewall
    include testvm
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
} 

# gandi-vm
node krampouezh {
# Location: gandi VM
#
# TODO:
# - secondary MX
# - LDAP slave (for external traffic maybe)
#
    #include common::default_mageia_server
    include common::default_mageia_server_no_smtp
    include postfix::secondary_smtp
    include blog::base
    include blog::db_backup
    include mysql::server
    include dns::server 
    timezone::timezone { "Europe/Paris": }
# Other services running on this server :
# - meetbot
}

node champagne {
# Location: gandi VM
#
# TODO:
# - setup mageia.org web site
# - setup blog
# - setup planet
#
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include blog::files-bots
    include blog::files_backup
    include planet
    include websites::static
}

node friteuse {
# Location: VM hosted by nfrance (toulouse)
# 
# TODO:
# - setup forum

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
    include draklive::base
    include access_classes::iso_makers
    include openssh::ssh_keys_from_ldap
    include mirror::mirrormageia
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

    libvirtd::download::netboot_images { "mandriva":
        path => $netinst_iso_path,
        versions => ["2010.0","2010.1"],
        archs => ['i586','x86_64'],
        mirror_path => "ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/official/%{version}/%{arch}/install/images/",
        files => ['boot.iso'],
        require => File[$netinst_iso_path],
    }

}
