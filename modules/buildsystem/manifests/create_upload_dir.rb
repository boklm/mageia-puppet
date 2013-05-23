hostclass "buildsystem::create_upload_dir" do
    include 'buildsystem::var::scheduler'
    include 'buildsystem::var::distros'
    states = ["todo","done","failure","queue","rejected"]
    owner = scope.lookupvar('buildsystem::var::scheduler::login')
    group = owner
    uploads_dir = scope.lookupvar('buildsystem::var::scheduler::homedir') + '/uploads'

    file uploads_dir, :ensure => 'directory', :owner => owner, :group => group 

    for st in states do
        file [uploads_dir, st].join('/'), :ensure => 'directory', :owner => owner, :group => group 
        
        scope.lookupvar('buildsystem::var::distros::distros').each{|rel, distro|
            file [uploads_dir, st, rel].join('/'), :ensure => 'directory', :owner => owner, :group => group
	    medias = distro['medias']
            medias.each{|media, m|
                file [uploads_dir, st, rel, media].join('/'), :ensure => 'directory', :owner => owner, :group => group
        
                for repo in m['repos'].keys do
                    if st == 'done'
                       file [uploads_dir, st, rel, media, repo].join('/'), :ensure => 'directory', :owner => owner, :group => group, :mode => 0775
                    else
                       file [uploads_dir, st, rel, media, repo].join('/'), :ensure => 'directory', :owner => owner, :group => group
                    end
                end 
            }
        }
    end
end
