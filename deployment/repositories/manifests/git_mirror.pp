class repositories::git_mirror {
    file { "/git":
        ensure => directory,
    }

    git::mirror { "/git/forum/":
        description => "Reference code for forum.$domain",
        source => "git://git.$domain/forum/"
    }
}

