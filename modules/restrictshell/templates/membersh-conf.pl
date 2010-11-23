

$bin_svn = "/usr/bin/svnserve";
$regexp_svn = "^svnserve -t\$";
#@prepend_args_svn = ( '-r', '/svn' );
@prepend_args_svn = ();

$bin_git = "/usr/bin/git-shell";

$bin_rsync = "/usr/bin/rsync";
$regexp_rsync = "^rsync --server";
$regexp_dir_rsync = "^/.*";


foreach my $f (glob("/etc/membersh-conf.d/allow_*pl")) {
    do($f)
}
1;
