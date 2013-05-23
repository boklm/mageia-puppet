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
# $clean_uploads_logs_age:
#   old logs are cleaned when they are older than some amount of time.
#   You can define this amount of time using this variable. Set it to
#   '2w' for two weeks, '2d' for two days, or '0' if you don't want to
#   clean old logs at all
class buildsystem::var::scheduler(
    $admin_mail = "root@${::domain}",
    $pkg_uphost = "pkgsubmit.${::domain}",
    $build_nodes,
    $build_nodes_aliases = {},
    $build_src_node,
    $clean_uploads_logs_age = '2w'
){
    $login = 'schedbot'
    $homedir = "/var/lib/$login"
    $logdir = "/var/log/$login"
}
