# $admin_mail:
#   the email address from which the build failure notifications
#   will be sent
class buildsystem::var::scheduler(
    $admin_mail = "root@${::domain}"
){
    $login = 'schedbot'
    $homedir = "/var/lib/$login"
    $logdir = "/var/log/$login"
}
