class buildsystem::mgacreatehome {
    # temporary script to create home dir with ssh key
    # taking login and url as arguments
    local_script { 'mgacreatehome':
        content => template('buildsystem/mgacreatehome')
    }
}
