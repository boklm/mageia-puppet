hostclass "buildsystem::distros" do
    include 'buildsystem::var::repository'
    include 'buildsystem::var::scheduler'
    include 'buildsystem::var::distros'

    mirror_user = 'root'
    schedbot_user = scope.lookupvar('buildsystem::var::scheduler::login')
    bootstrap_reporoot = scope.lookupvar('buildsystem::var::repository::bootstrap_reporoot')
    scope.lookupvar('buildsystem::var::distros::distros').each{|rel, distro|
	file [ bootstrap_reporoot, rel ].join('/'), :ensure => 'directory', 
	    :owner => mirror_user, :group => mirror_user
	for arch in distro['arch'] do
	    file [ bootstrap_reporoot, rel, arch ].join('/'), 
		:ensure => 'directory', :owner => mirror_user, 
		:group => mirror_user
	    mediadir = [ bootstrap_reporoot, rel, arch, 'media' ].join('/')
	    file mediadir, :ensure => 'directory', :owner => mirror_user,
		:group => mirror_user
	    file [ mediadir, 'media_info' ].join('/'), :ensure => 'directory',
		:owner => mirror_user, :group => mirror_user
	    file [ mediadir, 'debug' ].join('/'), :ensure => 'directory',
		:owner => mirror_user, :group => mirror_user
	    distro['medias'].each{|media, m|
		file [ mediadir, media ].join('/'), :ensure => 'directory', 
		    :owner => schedbot_user, :group => schedbot_user
		file [ mediadir, 'debug', media ].join('/'), 
		    :ensure => 'directory', :owner => schedbot_user, 
		    :group => schedbot_user
		for repo in m['repos'].keys do
		    file [ mediadir, media, repo ].join('/'),
			:ensure => 'directory', :owner => schedbot_user,
			:group => schedbot_user
		    file [ mediadir, 'debug', media, repo ].join('/'),
			:ensure => 'directory', :owner => schedbot_user,
			:group => schedbot_user
		end
	    }
	end
    }
end
