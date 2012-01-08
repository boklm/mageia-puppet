class websites { 
    class svn {
        apache::vhost_redirect { "svn.$domain":
            url => "http://svnweb.$domain/",
        }
    }
}
