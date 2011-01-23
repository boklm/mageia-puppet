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
    include default_mageia_server
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
    include restrictshell::allow_svn
    include restrictshell::allow_pkgsubmit
    # disabled the ldap key here instead of disabling for the
    # whole module ( see r698 )
    #include openssh::ssh_keys_from_ldap

    include repositories::subversion

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
    include default_mageia_server_no_smtp
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
        host_aliases => [ "friteuse.$domaine" ],
        ensure => 'present',
    }

    include lists
    include dns::server 
}

# buildnode
node jonund {
# Location: IELO datacenter (marseille)
#
    include default_mageia_server
    include buildsystem::buildnode
    timezone::timezone { "Europe/Paris": }
    include shorewall
    include shorewall::default_firewall
    include testvm
}

node ecosse {
# Location: IELO datacenter (marseille)
#
    include default_mageia_server
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
    include default_mageia_server
} 

# gandi-vm
node krampouezh {
# Location: gandi VM
#
# TODO:
# - secondary MX
# - LDAP slave (for external traffic maybe)
#
    include default_mageia_server
    # TODO uncomment when ready to be tested
    #include default_mageia_server_no_smtp
    #include postfix::secondary_smtp

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
#
    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include blog
}

node friteuse {
# Location: VM hosted by nfrance (toulouse)
# 
# TODO:
# - setup forum

    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
}

node rabbit {
# Location: Server offered by Dedibox (paris)
# 
# - used to create isos ( and live, and so on )
# 
    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include bcd::base
    include access_classes::iso_makers
    include openssh::ssh_keys_from_ldap
    include mirror::mirrorbootstrap
    include mirror::mirrormageia
}
