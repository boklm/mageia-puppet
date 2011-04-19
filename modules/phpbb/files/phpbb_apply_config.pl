#!/usr/bin/perl
use strict;
use warnings;
use Env qw(VALUE);
use DBI;

my $key = $ARGV[0];

# DBI will use default value coming from env
# see puppet manifests 
my $dbh = DBI->connect("dbi:Pg:","","", {
    AutoCommit => 0,
    RaiseError => 1,
});

my $table = "phpbb_config";

# FIXME add rollback if there is a problem 
# http://docstore.mik.ua/orelly/linux/dbi/ch06_03.htm
my $update = $dbh->prepare("UPDATE $table SET config_value = ?, is_dynamic = ? WHERE config_name = ?");
my $insert = $dbh->prepare("INSERT INTO $table ( config_value, is_dynamic, config_name ) VALUES ( ? , ? , ? )");

my $res = $update->execute($VALUE, 1, $key) or die "cannot do update $?";
if ($res == 0 ) {
     $insert->execute($VALUE, 1, $key) or die "cannot do insert $?";
}
$dbh->commit();
$dbh->disconnect();
