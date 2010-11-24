# svn, big important server
node valstar {
# Location: IELO datacenter (marseille)
#
# TODO:
# - GIT server
# - setup urli build scheduler
# - setup youri
# - setup restricted shell access to allow "mdvsys submit" to work
# - setup maintainers database (with web interface)
# - mirroring (Nanar)
#
    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include rsyncd
    include mirror
    include openldap::master 
    include subversion::client
    include subversion::server
    include puppet::master
    include ssh::auth
    include ssh::auth::keymaster
    include buildsystem::mainnode

    include pam::committers_access
    include restrictshell::allow_svn

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
    include default_mageia_server
    include bind::bind_master
    include postgresql
    bind::zone_master { "mageia.org": }
    bind::zone_master { "mageia.fr": } 
    timezone::timezone { "Europe/Paris": }

    include catdap
    include mga-mirrors
    include epoll
    include transifex
    include bugzilla
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
    include bind::bind_master
    bind::zone_master { "mageia.org": }
    bind::zone_master { "mageia.fr": } 
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


