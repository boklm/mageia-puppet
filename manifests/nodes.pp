# svn, big important server
node valstar {
# Location: IELO datacenter (marseille)
#
# TODO:
# - SVN server
# - GIT server
# - setup urli build scheduler
# - setup youri
# - setup restricted shell access to allow "mdvsys submit" to work
# - setup maintainers database (with web interface)
# - mirroring (Nanar)
# - LDAP master
#
    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include rsyncd
    include mirror
    include openldap::master 
    include subversion::client
    include subversion::server
    

    subversion::snapshot { "/etc/puppet":
        source => "svn://vm-gandi.mageia.org/adm/puppet/"
    }

    file { "extdata":
        path => "/etc/puppet/extdata",
        ensure => directory,
        owner => puppet,
        group => puppet,
        mode => 700,
        recurse => true
    }

    package {"puppet-server":
        ensure => "installed"
    }

    package {"task-bs-cluster-main":
        ensure => "installed"
    }
}

# web apps
node alamut {
# Location: IELO datacenter (marseille)
#
# TODO:
# - bugzilla
# - nagios
# - api
# - mail server
# - mailing list server
# - wiki
# - pastbin
# - LDAP slave
# - transifex
# - SQL server
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
}

# buildnode
node jonund {
# Location: IELO datacenter (marseille)
#
	include default_mageia_server
	include iurt
    timezone::timezone { "Europe/Paris": }
}

node ecosse {
# Location: IELO datacenter (marseille)
#
	include default_mageia_server
	include iurt
    timezone::timezone { "Europe/Paris": }
}


# backup server
node fiona {
# Location: IELO datacenter (marseille)
#
# TODO:
# - buy the server
# - install the server in datacenter
#
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
    include apache::base
}


