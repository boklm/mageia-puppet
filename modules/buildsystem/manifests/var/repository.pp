class buildsystem::var::repository(
    $bootstrap_root = '/distrib/bootstrap',
    $mirror_root = '/distrib/mirror',
    $distribdir = 'distrib',
) {
    $bootstrap_reporoot = "${bootstrap_root}/${distribdir}"
    $mirror_reporoot = "${mirror_root}/${distribdir}"
}
