# that's not for a real node called default, but
# config applied to every node
node default {
    include common::default_mageia_server
}

import "nodes/*.pp"
