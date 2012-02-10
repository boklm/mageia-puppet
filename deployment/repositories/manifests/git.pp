class repositories::git {
    git::repository { '/git/forum':
        description => "Reference code for forum.$::domain",
        group       => 'mga-forum-developers',
    }

    git::repository { '/git/initscripts':
        description => 'Source for initscripts package',
        group       => 'mga-packagers-committers',
    }
}
