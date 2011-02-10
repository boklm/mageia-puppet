class repositories::git {
    file { "/git":
        ensure => directory,
        owner => root,
        group => root,
        mode => 755, 
    }

    git::repository { "/git/forum":
        description => "Reference code for forum.$domain",
        group => "mga-forum-developers", 
    }
}
