#!/usr/bin/perl
use warnings;
use strict;
use Proc::Daemon;
my $nick = "<%= nick %>";
my $server = "<%= server %>";

Proc::Daemon::Init();
fork() || exec "ii -n $nick -i /var/lib/ii/$nick -s $server";
wait();
