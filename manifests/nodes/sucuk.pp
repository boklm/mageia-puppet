# server for various task
node sucuk {
# Location: IELO datacenter (marseille)
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }

    include openssh::ssh_keys_from_ldap
    include access_classes::admin
    include mga_buildsystem::buildnode
}
