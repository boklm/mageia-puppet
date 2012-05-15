node champagne {
# Location: gandi VM
#
# TODO:
# - setup mageia.org web site
#
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }
    include blog::files_bots
    include blog::files_backup
    include planet
    include websites::static
    include websites::hugs
    include websites::releases
    include websites::www
    include websites::nav
    include websites::doc
    include dashboard
    include access_classes::web
    include openssh::ssh_keys_from_ldap
}
