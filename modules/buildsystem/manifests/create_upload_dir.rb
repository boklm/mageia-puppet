define "create_upload_dir", :owner do

    states = ["todo","done","failure","queue","rejected"]
    releases = ["cauldron"]
    repositories = ["core","nonfree","tainted"]
    medias = ['release','updates_testing','backports_testing','backports','updates']

    for st in states do
        file [@name, st].join('/'), :ensure => 'directory', :owner => @owner    
        
        for rel in releases do
            file [@name, st, rel].join('/'), :ensure => 'directory', :owner => @owner    
        
            for rep in repositories do
                file [@name, st, rel, rep].join('/'), :ensure => 'directory', :owner => @owner    
        
                for med in medias do
                    file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner
                end 
            end
        end
    end
end
