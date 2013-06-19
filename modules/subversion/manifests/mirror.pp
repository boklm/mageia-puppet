class subversion::mirror {
    include subversion::tools
    mga_common::local_script { 'create_svn_mirror.sh':
        content => template('subversion/create_svn_mirror.sh')
    }
}
