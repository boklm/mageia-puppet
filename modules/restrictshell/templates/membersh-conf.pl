

$bin_svn = "/usr/bin/svnserve";
$regexp_svn = "^svnserve -t\$";
#@prepend_args_svn = ( '-r', '/svn' );
@prepend_args_svn = ();

$bin_git = "/usr/bin/git-shell";

$bin_rsync = "/usr/bin/rsync";
$regexp_rsync = "^rsync --server";
$regexp_dir_rsync = "^/.*";

$bin_sftp = "<%= lib_dir %>/ssh/sftp-server";
$regexp_sftp = "^(/usr/lib{64,}/ssh/sftp-server|/usr/lib/sftp-server|/usr/libexec/sftp-server|/usr/lib/openssh/sftp-server)";

foreach my $f (glob("/etc/membersh-conf.d/allow_*pl")) {
    do($f)
}
1;
