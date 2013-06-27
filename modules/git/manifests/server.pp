class git::server {
    include git::common

    $git_base_path = '/git/'

    xinetd::service { 'git':
        content => template('git/xinetd')
    }

    file { '/usr/local/bin/create_git_repo.sh':
        mode   => '0755',
        source => 'puppet:///modules/git/create_git_repo.sh',
    }

    file { '/usr/local/bin/apply_git_puppet_config.sh':
        mode   => '0755',
        source => 'puppet:///modules/git/apply_git_puppet_config.sh',
    }


    # TODO
    # define common syntax check, see svn
    #          http://stackoverflow.com/questions/3719883/git-hook-syntax-check
    #        proper policy : fast-forward-only
    #              ( http://progit.org/book/ch7-4.html )
    #            no branch ?
    #            no binary
    #            no big file
    #            no empty commit message
    #            no commit from root
    #        see http://www.itk.org/Wiki/Git/Hooks
    #        automated push to another git repo ( see http://noone.org/blog/English/Computer/VCS/Thoughts%20on%20Gitorious%20and%20GitHub%20plus%20a%20useful%20git%20hook.futile
    #
    # how do we handle commit permission ?
    #   mail sending
    #
}
