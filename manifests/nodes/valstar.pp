# svn, big important server
node valstar {
# Location: IELO datacenter (marseille)
#
# TODO:
# - GIT server
# - setup maintainers database (with web interface)
#
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }
    include main_mirror
    include openldap::master
    include subversion::client
    include subversion::server
    include puppet::master
    include reports::ii

    include sshkeys::keymaster
    include mga_buildsystem::mainnode
    include softwarekey
    include mgasoft

    include access_classes::committers
    include restrictshell::allow_svn
    include restrictshell::allow_pkgsubmit
    include restrictshell::allow_maintdb
    include restrictshell::allow_upload_bin
    include openssh::ssh_keys_from_ldap

    include mirror::mdv2010spring

    include repositories::subversion

    include irkerd

    include websites::svn

    class { 'mga-advisories':
        vhost => 'advisories.mageia.org',
    }

    subversion::snapshot { '/etc/puppet':
        source => 'svn://svn.mageia.org/svn/adm/puppet/'
    }

    mirror_cleaner::orphans {  'cauldron':
        base => '/distrib/bootstrap/distrib/',
    }

    class { 'mgagit':
        ldap_server => 'ldap.mageia.org',
        binddn      => 'cn=mgagit-valstar,ou=System Accounts,dc=mageia,dc=org',
        bindpw      => extlookup('mgagit_ldap','x'),
    }
}
