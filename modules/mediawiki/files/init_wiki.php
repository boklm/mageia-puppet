<?
$wiki_root = $argv[1];
$mw_root = '/usr/share/mediawiki';

if (!is_dir("$wiki_root/config")) {
    exit(1);
}

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

$dir = "$wiki_root/config";
foreach (scandir($dir) as $item) {
        if (!is_dir($item) || is_link($item))
                unlink($item); 
}
rmdir("$dir");
?>
