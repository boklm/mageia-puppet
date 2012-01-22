#!/usr/bin/perl
use warnings;
use strict;
use POSIX;
use Proc::Daemon;
my $nick = "<%= nick %>";
my $server = "<%= server %>";


Proc::Daemon::Init();
my (undef, undef, $uid) = getpwnam("nobody");
POSIX::setuid($uid);

fork() || exec "ii -n $nick -i /var/lib/ii/$nick -s $server";
wait();
