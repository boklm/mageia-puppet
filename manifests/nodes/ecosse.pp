node ecosse {
# Location: IELO datacenter (marseille)
#
    include common::default_mageia_server
    include buildsystem::buildnode
    timezone::timezone { "Europe/Paris": }
}
