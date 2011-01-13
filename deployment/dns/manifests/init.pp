
class dns {
    class server {
        include bind::bind_master
        dns::zone { "mageia.org": }
        dns::zone { "mageia.fr": } 

        dns::reverse_zone { "7.0.0.0.2.0.0.0.8.7.1.2.2.0.a.2.ip6.arpa": }
    }

    define zone {
        bind::zone_master { $name:
            content => template("dns/$name.zone")
        }        
    }

    define reverse_zone {
        bind::zone_reverse { $name:
            content => template("dns/$name.zone")
        }
    }
}
