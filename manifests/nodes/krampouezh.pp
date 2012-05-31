# gandi-vm
node krampouezh {
# Location: gandi VM
#
#
    #include common::default_mageia_server
    include common::default_mageia_server_no_smtp
    include postfix::server::secondary
    include blog::base
    include blog::db_backup
    include mysql::server
    include dns::server
    timezone::timezone { 'Europe/Paris': }

    openldap::slave_instance { '1':
        rid => 1,
    }

    # http server for meetbot logs
    include apache::base

    # temporary protection for CVE-2011-3192
    include apache::cve-2011-3192

# Other services running on this server :
# - meetbot
}
