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
    include restrictshell::allow_pkgsubmit

    subversion::repository { "/svn/adm/":
        group => "mga-sysadmin",
        commit_mail => "mageia-sysadm@mageia.org",
        syntax_check => ['check_puppet_templates','check_puppet'],
    }

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
    include dns_server 
    timezone::timezone { "Europe/Paris": }

    include catdap
    include websites::donate
    include mga-mirrors
    include epoll
    include transifex
    include bugzilla
    include sympa::server
    include postfix::primary_smtp
  
    # please check that the list use the proper code for
    # language ( not to be confused with tld or country code )
    sympa::public_list {"i18n-af":
        subject => "List about translation in Afrikaans",
        topics => "i18n",
    }

    sympa::public_list {"i18n-de":
        subject => "List about translation in German",
        topics => "i18n",
    }

    sympa::public_list {"i18n-et":
        subject => "List about translation in Estonian",
        topics => "i18n",
    }

    sympa::public_list {"i18n-fr":
        subject => "List about translation in French",
        topics => "i18n",
    }

    sympa::public_list {"i18n-nl":
        subject => "List about translation in Dutch",
        topics => "i18n",
    }

    sympa::public_list {"i18n-pt_br":
        subject => "List about translation in Brazilian Portuguese",
        topics => "i18n",
    }

    sympa::public_list {"i18n-pl":
        subject => "List about translation in Polish",
        topics => "i18n",
    }

    sympa::public_list {"i18n-ru":
        subject => "List about translation in Russian",
        topics => "i18n",
    }

    sympa::public_list {"i18n-tr":
        subject => "List about translation in Turkish",
        topics => "i18n",
    }

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

    include dns_server 
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
# Location: VM hosted by nfrance
# 
# TODO:
# - setup forum

    include default_mageia_server
    timezone::timezone { "Europe/Paris": }
}
