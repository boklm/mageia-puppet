define dns::zone {
    bind::zone::master { $name:
        content => template("dns/$name.zone")
    }
}
