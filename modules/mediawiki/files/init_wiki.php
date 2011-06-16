<?
$wiki_root = $argv[1];
$mw_root = '/usr/share/mediawiki';

// DefaultSettings.php complain if not defined
define('MEDIAWIKI',1);

require_once("$mw_root/includes/Defines.php");
require_once("$mw_root/includes/AutoLoader.php");
require_once("$mw_root/includes/GlobalFunctions.php");
include("$wiki_root/LocalSettings.php");

$dbclass = 'Database'.ucfirst($wgDBtype);
$dbc = new $dbclass;

$wgDatabase = $dbc->newFromParams($wgDBserver,
                                  $wgDBuser,
                                  $wgDBpassword, $wgDBname, 1);

$wgDatabase->initial_setup($wgDBpassword, $wgDBname);
$wgDatabase->setup_database();

rmdir("$wiki_root/config");
?>
