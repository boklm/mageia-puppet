# $svn_url:
#   svn url where the sources of webstatus are located
# $hostname:
#   vhost name of the webstatus page
# $location:
#   path of the directory where the webstatus files are located
class buildsystem::var::webstatus(
    $svn_url = "svn://svn.mageia.org/soft/build_system/web/",
    $hostname = "pkgsubmit.$::domain",
    $location = '/var/www/bs'
) {
}
