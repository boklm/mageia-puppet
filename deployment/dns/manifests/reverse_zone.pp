define dns::reverse_zone {
    bind::zone::reverse { $name:
        content => template("dns/$name.zone")
    }
}
