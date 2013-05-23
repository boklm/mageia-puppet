hostclass "buildsystem::create_upload_dir" do
    states = ["todo","done","failure","queue","rejected"]
    owner = scope.lookupvar('buildsystem::var::scheduler::login')
    group = owner
    uploads_dir = scope.lookupvar('buildsystem::var::scheduler::homedir') + '/uploads'

    file uploads_dir, :ensure => 'directory', :owner => owner, :group => group 

    for st in states do
        file [uploads_dir, st].join('/'), :ensure => 'directory', :owner => owner, :group => group 
        
        scope.lookupvar('buildsystem::mgarepo::releases').each{|rel, repositories|
            file [uploads_dir, st, rel].join('/'), :ensure => 'directory', :owner => owner, :group => group
        
            repositories.each{|rep, medias|
                file [uploads_dir, st, rel, rep].join('/'), :ensure => 'directory', :owner => owner, :group => group
        
                for med in medias do
                    if st == 'done'
                       file [uploads_dir, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => owner, :group => group, :mode => 0775
                    else
                       file [uploads_dir, st, rel, rep, med].join('/'), :ensure => 'directory', :owner => owner, :group => group
                    end
                end 
            }
        }
    end
end
