#!/usr/bin/perl
use strict;
use warnings;
use Env qw(VALUE);
use DBI;

my $key = $ARGV[0];

# DBI will use default value coming from env
# see puppet manifests 
my $dbh = DBI->connect("dbi:Pg:","","");

my $table = "phpbb_config";

my $update = $dbh->prepare("UPDATE $table SET config_value = ?, is_dynamic = ? WHERE config_name = ?");
my $insert = $dbh->prepare("INSERT INTO $table ( config_value, is_dynamic, config_name ) VALUES ( ? , ? , ? )");

my $res = $update->execute($VALUE, 1, $key) or die "cannot do update $?";
if ($res == 0 ) {
     $insert->execute($VALUE, 1, $key) or die "cannot do insert $?";
}

