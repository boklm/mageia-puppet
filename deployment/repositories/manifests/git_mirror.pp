class repositories::git_mirror {
    file { "/git":
        ensure => directory,
    }

    git::mirror { "/git/forum/":
        description => "Reference code for forum.$domain",
        source => "git://git.$domain/forum/"
    }

    git::mirror { "/git/initscripts/":
        description => "Reference code for Initscripts",
        source => "git://git.$domain/initscripts/"
    }
}

