class repositories::git {
    git::repository { "/git/forum":
        description => "Reference code for forum.$domain",
        group => "mga-forum-developers", 
    }
}
