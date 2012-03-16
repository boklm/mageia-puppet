class buildsystem::repository {
   $dir = '/distrib/bootstrap'
   file { $dir:
        ensure => directory,
   }
}
