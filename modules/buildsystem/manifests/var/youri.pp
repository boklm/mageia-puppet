# $tmpl_youri_upload_conf:
#   template file for youri submi-upload.conf
# $tmpl_youri_todo_conf:
#   template file for youri submit-todo.conf
# $packages_archivedir:
#   the directory where youri will archive old packages when they are
#   replaced by a new version
class buildsystem::var::youri(
    $tmpl_youri_upload_conf = 'buildsystem/youri/submit-upload.conf',
    $tmpl_youri_todo_conf = 'buildsystem/youri/submit-todo.conf',
    $packages_archivedir
) {
}
