class git::svn {
    include git::client
    package { 'git-svn': }
}
