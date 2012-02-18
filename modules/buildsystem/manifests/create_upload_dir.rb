define "create_upload_dir", :owner, :group, :releases do
    states = ["todo","done","failure","queue","rejected"]

    file @name, :ensure => 'directory', :owner => @owner, :group => @group 

    for st in states do
        file [@name, st].join('/'), :ensure => 'directory', :owner => @owner, :group => @group 
        
        @releases.each{|rel, repositories|
            file [@name, st, rel].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
        
            repositories.each{|rep, medias|
                file [@name, st, rel, rep].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
        
                for med in medias do
                    if st == 'done'
                       file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner, :group => @group, :mode => 0775
                    else
                       file [@name, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => @owner, :group => @group
                    end
                end 
            }
        }
    end
end
