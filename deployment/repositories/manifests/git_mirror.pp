class repositories::git_mirror {
    file { "/git":
        ensure => directory,
    }

    git::mirror { "/git/forum/":
        source => "git://git.$domain/forum/"
    }
}

