# web apps
node alamut {
# Location: IELO datacenter (marseille)
#
# TODO:
# - Review board
# - api
# - pastebin
# - LDAP slave
#
    include common::default_mageia_server_no_smtp
    include postgresql::server
    postgresql::tagged { 'default': }

    timezone::timezone { 'Europe/Paris': }

    include catdap
    include mga-mirrors
    include epoll
    include transifex
    include bugzilla
    include sympa::server
    include postfix::server::primary

    # temporary, just the time the vm is running there
    host { 'friteuse':
        ensure       => 'present',
        ip           => '192.168.122.131',
        host_aliases => [ "friteuse.$domain", "forums.$domain" ],
    }

    # to create all phpbb database on alamut
    phpbb::databases { $fqdn: }

    apache::vhost::redirect_ssl { "forums.$domain": }
    apache::vhost_redirect { "forum.$domain":
        url => "https://forums.$domain/",
    }
    apache::vhost_redirect { "ssl_forum.$domain":
        url     => "https://forums.$domain/",
        vhost   => "forum.$domain",
        use_ssl => true,
    }

    # connect to ssl so the proxy do not shoke if trying to
    # enforce ssl ( note that this has not been tested, maybe this
    # is uneeded )
    apache::vhost_reverse_proxy { "ssl_forums.$domain":
        url     => "https://forums.$domain/",
        vhost   => "forums.$domain",
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
        location => '/var/lib/xymon/www',
    }

    youri-check::report_www { 'check': }

    youri-check::config {'config_cauldron':
        version => 'cauldron',
    }
    youri-check::report { 'report_cauldron':
        version => 'cauldron',
        hour    => '*',
        minute  => '24'
    }

    youri-check::config {'config_1':
        version => '1',
    }
    youri-check::report {'report_1':
        version => '1',
        hour    => '*',
        minute  => '54'
    }

    include wikis
    include websites::pkgcpan
}
