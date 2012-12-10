# buildnode
node jonund {
# Location: IELO datacenter (marseille)
#
    include common::default_mageia_server
    include mga_buildsystem::buildnode
    include buildsystem::iurt20101
    timezone::timezone { 'Europe/Paris': }
#    include shorewall
#    include shorewall::default_firewall
}
