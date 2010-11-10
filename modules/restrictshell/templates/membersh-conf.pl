$use_svn = "<%= allow_svn %>";
$bin_svn = "/usr/bin/svnserve";
$regexp_svn = "^svnserve -t\$";
#@prepend_args_svn = ( '-r', '/svn' );
@prepend_args_svn = ();

$use_git = "<%= allow_git %>";
$bin_git = "/usr/bin/git-shell";

$use_rsync = "<%= allow_rsync %>";
$bin_rsync = "/usr/bin/rsync";
$regexp_rsync = "^rsync --server";
$regexp_dir_rsync = "^/.*";

$use_pkgsubmit = "<%= allow_pkgsubmit %>";

