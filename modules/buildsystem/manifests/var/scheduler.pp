# $admin_mail:
#   the email address from which the build failure notifications
#   will be sent
# $pkg_uphost:
#   hostname of the server where submitted packages are uploaded
# $build_nodes:
#   a hash containing available build nodes indexed by architecture
# $build_nodes_aliases:
#   a hash containing build nodes indexed by their alias
# $build_src_node:
#   hostname of the server building the initial src.rpm
class buildsystem::var::scheduler(
    $admin_mail = "root@${::domain}",
    $pkg_uphost = "pkgsubmit.${::domain}",
    $build_nodes,
    $build_nodes_aliases = {},
    $build_src_node
){
    $login = 'schedbot'
    $homedir = "/var/lib/$login"
    $logdir = "/var/log/$login"
}
