define "create_upload_dir", :owner, :group do

    states = ["todo","done","failure","queue","rejected"]
    releases = ["cauldron", "1"]
    repositories = ["core","nonfree","tainted"]
    medias = ['release','updates_testing','backports_testing','backports','updates']

    file @name, :ensure => 'directory', :owner => @owner, :group => @group 

    for st in states do
        file [@name, st].join('/'), :ensure => 'directory', :owner => @owner, :group => @group 
        
        for rel in releases do
            file [@name, st, rel].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
        
            for rep in repositories do
                file [@name, st, rel, rep].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
        
                for med in medias do
		    if st == 'done'
                       file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner, :group => @group, :mode => 0775
		    else
                       file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
		    end
                end 
            end
        end

	rel 'infra_1'
	rep = 'core'
	med = 'release'
	file [@name, st, rel].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
	file [@name, st, rel, rep].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
	file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner, :group => @group, :mode => 0775
    end
end
