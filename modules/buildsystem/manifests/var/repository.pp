class buildsystem::var::repository(
    $bootstrap_reporoot = '/distrib/bootstrap',
    $mirror_root = '/distrib/mirror',
    $distribdir = 'distrib',
) {
    $mirror_reporoot = "${mirror_root}/${distribdir}"
}
