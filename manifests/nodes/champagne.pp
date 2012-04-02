node champagne {
# Location: gandi VM
#
# TODO:
# - setup mageia.org web site
#
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }
    include blog::files-bots
    include blog::files_backup
    include planet
    include websites::static
    include websites::hugs
    include websites::releases
    include websites::www
    include dashboard::base
    include access_classes::web
    include openssh::ssh_keys_from_ldap
}
