class buildsystem {
    # temporary script to create home dir with ssh key
    # taking login and url as arguments
    class mgacreatehome {
        local_script { "mgacreatehome":
            content => template("buildsystem/mgacreatehome")
	    }
    }
}
