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

    include ssh::auth
    include ssh::auth::keymaster
    include buildsystem::mainnode
    include buildsystem::sync20101
    include buildsystem::release
    include buildsystem::maintdb
    include buildsystem::binrepo
    include softwarekey
    include mgasoft

    include access_classes::committers
    include restrictshell::allow_git
    include restrictshell::allow_svn
    include restrictshell::allow_pkgsubmit
    include restrictshell::allow_maintdb
    include restrictshell::allow_upload_bin
    # disabled the ldap key here instead of disabling for the
    # whole module ( see r698 )
    class { 'openssh::ssh_keys_from_ldap':
    	symlink_users => ['schedbot', 'iurt']
    }

    include mirror::mdv2010spring

    include repositories::subversion
    include repositories::git
    include repositories::sparkleshare

    include websites::svn

    subversion::snapshot { '/etc/puppet':
        source => 'svn://svn.mageia.org/svn/adm/puppet/'
    }

    mirror_cleaner::orphans {  'cauldron':
        base => '/distrib/bootstrap/distrib/',
    }

    # TODO use a dns zone for that
    host { 'arm1':
        ip           => '10.10.10.11',
        host_aliases => [ "arm1.$::domain" ],
        ensure       => present,
    }

    host { 'arm2':
        ip           => '10.10.10.12',
        host_aliases => [ "arm2.$::domain" ],
        ensure       => present,
    }
}
