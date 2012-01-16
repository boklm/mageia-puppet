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
