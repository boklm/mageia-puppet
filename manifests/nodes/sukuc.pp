# server for various task
node sukuc {
# Location: IELO datacenter (marseille)
    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
}
