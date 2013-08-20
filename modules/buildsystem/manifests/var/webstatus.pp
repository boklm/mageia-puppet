# $git_url:
#   git url where the sources of webstatus are located
# $hostname:
#   vhost name of the webstatus page
# $location:
#   path of the directory where the webstatus files are located
# $package_commit_url:
#   url to view a commit on a package. %d is replaced by the commit id.
# $max_modified:
#   how much history should we display, in days
# $theme_name:
#   name of the webstatus theme
# $themes_dir:
#   path of the directory where the themes are located. If you want
#   to use a theme not included in webstatus, you need to change this.
class buildsystem::var::webstatus(
    $git_url = "git://git.mageia.org/web/pkgsubmit",
    $hostname = "pkgsubmit.$::domain",
    $location = '/var/www/bs',
    $package_commit_url,
    $max_modified = '2',
    $theme_name = 'mageia',
    $themes_dir = '/var/www/bs/themes/'
) {
}
