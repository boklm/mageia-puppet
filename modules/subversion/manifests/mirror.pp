class subversion::mirror {
    include subversion::tools
    local_script { 'create_svn_mirror.sh':
        content => template('subversion/create_svn_mirror.sh')
    }
}
