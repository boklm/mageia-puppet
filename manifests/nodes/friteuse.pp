node friteuse {
# Location: VM hosted by nfrance (toulouse)
# 

    include common::default_mageia_server
    timezone::timezone { "Europe/Paris": }
    include forums
}
