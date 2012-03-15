class puppet::stored_config {
# TODO uncomment when the following problem have been fixed 
#   - how to bootstrap the installation of the infrastructure ( since we use
#     stored_config for postgresql::remote_db_and_user, we need to have a sqlite3 
#     database first and then declare the database, and then switch to it )
#   - how do we decide when we get sqlite3 ( for small test servers ) and
#     when do we decide to get the real pgsql server ( for production setup )
#
#    if ($::environment == 'production') {
#        # FIXME not really elegant, but we do not have much choice
#        # this make servers not bootstrapable for now
#        $pgsql_password = extlookup('puppet_pgsql','x')
#
#        postgresql::remote_db_and_user { 'bugs':
#            description => 'Puppet database',
#            password => $pgsql_password,
#        }
#
#        $database = 'pg'
#    } else {
        $database = 'sqlite3'
#    }
#
    $db_config = template('puppet/db_config.erb')
}
