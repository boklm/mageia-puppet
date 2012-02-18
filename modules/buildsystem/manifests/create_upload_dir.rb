define "create_upload_dir", :owner, :group do

    #FIXME: move this config info outside of this code
    releases = {
        'cauldron' => { 
            'core' => ['release','updates_testing','backports_testing','backports','updates'],
            'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
            'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
        },
        '1' => { 
            'core' => ['release','updates_testing','backports_testing','backports','updates'],
            'nonfree' => ['release','updates_testing','backports_testing','backports','updates'],
            'tainted' => ['release','updates_testing','backports_testing','backports','updates'],
        },
        'infra_1' => { 
            'infra' => ['release']
        },
    }
             

    states = ["todo","done","failure","queue","rejected"]

    file @name, :ensure => 'directory', :owner => @owner, :group => @group 

    for st in states do
        file [@name, st].join('/'), :ensure => 'directory', :owner => @owner, :group => @group 
        
        releases.each{|rel, repositories|
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
