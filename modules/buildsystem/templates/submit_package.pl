#!/usr/bin/perl
use strict;
use warnings;

my $svn_server = 'svn.<%= domain %>';
my $packagersgroup="<%= packagers_group %>";
my $createsrpm="<%= createsrpm_path %>";

my $login = getpwuid($<);
my (undef, undef, undef, $members) = getgrnam $packagersgroup;
if (not $members =~ /\b$login\b/) {
	print "You are not in $packagersgroup group\n";
	exit 1;
}

# for bug 914 
# https://bugs.mageia.org/show_bug.cgi?id=914
map { $_ =~ s|^svn\+ssh://$svn_server/|svn://$svn_server/| } @ARGV; 
exec $createsrpm , @ARGV;
