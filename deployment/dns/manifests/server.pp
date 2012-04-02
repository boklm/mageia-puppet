class dns::server {
    include bind::master
    dns::zone { 'mageia.org': }

    dns::reverse_zone { '7.0.0.0.2.0.0.0.8.7.1.2.2.0.a.2.ip6.arpa': }
    dns::reverse_zone { '2.1.0.0.0.0.0.1.b.0.e.0.1.0.a.2.ip6.arpa': }
}
