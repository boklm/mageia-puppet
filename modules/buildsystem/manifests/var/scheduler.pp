# $admin_mail:
#   the email address from which the build failure notifications
#   will be sent
# $build_nodes:
#   a hash containing available build nodes indexed by architecture
class buildsystem::var::scheduler(
    $admin_mail = "root@${::domain}",
    $build_nodes
){
    $login = 'schedbot'
    $homedir = "/var/lib/$login"
    $logdir = "/var/log/$login"
}
