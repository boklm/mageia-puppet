define locale_db($tag = 'default',
                 $user = $phpbb::base::user) {
    postgresql::database { $name:
        description => "$lang db for phpbb forum",
        user => $user,
        tag => $tag,
# this break due to the way it is remotely declared
# this should only be a issue in case of bootstrapping again 
#        require => Postgresql::User[$user]
    }
}
