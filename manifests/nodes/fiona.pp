# backup server
node fiona {
# Location: IELO datacenter (marseille)
#
# TODO:
# - install a backup system
    include common::default_mageia_server
    timezone::timezone { 'Europe/Paris': }
    include rsnapshot
}
