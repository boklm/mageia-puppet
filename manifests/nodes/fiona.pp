# backup server
node fiona {
# Location: IELO datacenter (marseille)
#
# TODO:
# - buy the server
# - install the server in datacenter
# - install a backup system
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
}
