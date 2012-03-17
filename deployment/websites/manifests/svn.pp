class websites::svn {
    apache::vhost_redirect { "svn.$::domain":
        url => "http://svnweb.$::domain/",
    }
}
