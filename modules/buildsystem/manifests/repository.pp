class buildsystem::repository {
   file { $buildsystem::var::repository::bootstrap_reporoot:
        ensure => directory,
   }
}
