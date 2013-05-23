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
	    # As ruby dsl cannot use defined resources, we have to use a
	    # workaround with 'find_resource_type' as described in this
	    # puppet issue: http://projects.puppetlabs.com/issues/11912
	    scope.find_resource_type 'buildsystem::media_cfg'
	    create_resource 'buildsystem::media_cfg',
		[ rel, ' ', arch ].join('/'), :distro_name => rel,
		:arch => arch
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
	    if distro['based_on'] != nil
		distro['based_on'].each{|bdistroname, medias|
		    file [ mediadir, bdistroname ].join('/'),
			:ensure => 'directory', :owner => mirror_user,
			:group => mirror_user
		    medias.each{|medianame, media|
			mdir = [ mediadir, bdistroname, medianame ].join('/')
			file mdir, :ensure => 'directory',
			    :owner => mirror_user, :group => mirror_user
			for reponame in media
			    file [ mdir, reponame ].join('/'),
				:ensure => 'link',
				:target => [ 
				    '../../../../..', bdistroname, arch,
				    'media', medianame, reponame ].join('/'),
				:owner => mirror_user, :group => mirror_user
			end
		    }
		}
	    end
	end
    }
end
