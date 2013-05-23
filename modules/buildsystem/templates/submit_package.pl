#!/usr/bin/perl
use strict;
use warnings;

my $svn_server = '<%= scope.lookupvar('buildsystem::var::mgarepo::svn_hostname') %>';
my $packagersgroup="<%= scope.lookupvar('buildsystem::var::groups::packagers') %>";

my $login = getpwuid($<);
my (undef, undef, undef, $members) = getgrnam $packagersgroup;
if (not $members =~ /\b$login\b/) {
	print "You are not in $packagersgroup group\n";
	exit 1;
}

# for bug 914 
# https://bugs.mageia.org/show_bug.cgi?id=914
map { $_ =~ s|^svn\+ssh://$svn_server/|svn://$svn_server/| } @ARGV; 
exec "/usr/share/mgarepo/create-srpm", @ARGV;
