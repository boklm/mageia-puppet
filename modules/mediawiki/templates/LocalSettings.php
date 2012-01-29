<?php

# This file was created by puppet, so any change will be overwritten

# See includes/DefaultSettings.php for all configurable settings
# and their default values, but don't forget to make changes in _this_
# file, not there.
#
# Further documentation for configuration settings may be found at:
# http://www.mediawiki.org/wiki/Manual:Configuration_settings

$IP = '/usr/share/mediawiki';
if (! isset($DIR)) $DIR = getcwd();

$path = array( $IP, "$IP/includes", "$IP/languages" );
set_include_path( implode( PATH_SEPARATOR, $path ) . PATH_SEPARATOR . get_include_path() );

require_once( "$IP/includes/DefaultSettings.php" );

if ( $wgCommandLineMode ) {
        if ( isset( $_SERVER ) && array_key_exists( 'REQUEST_METHOD', $_SERVER ) ) {
                die( "This script must be run from the command line\n" );
        }
}
## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

$wgSitename         = "<%= title %>";

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs please see:
## http://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath       = "/<%= path %>";
$wgScriptExtension  = ".php";

## The relative URL path to the skins directory
$wgStylePath        = "$wgScriptPath/skins";

## The relative URL path to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
$wgLogo             = "$wgStylePath/common/images/wiki.png";

## UPO means: this is also a user preference option

$wgEnableEmail      = true;
$wgEnableUserEmail  = true; # UPO

$wgEmergencyContact = "root@<%= domain %>";
$wgPasswordSender = "root@<%= domain %>";

$wgEnotifUserTalk = true; # UPO
$wgEnotifWatchlist = true; # UPO
$wgEmailAuthentication = true;

## Database settings
$wgDBtype           = "postgres";
$wgDBserver         = "pgsql.<%= domain %>";
$wgDBname           = "<%= db_name %>";
$wgDBuser           = "<%= db_user %>";
$wgDBpassword       = "<%= db_password %>";

# Postgres specific settings
$wgDBport           = "5432";
$wgDBmwschema       = "mediawiki";
$wgDBts2schema      = "public";

## Shared memory settings
$wgMainCacheType = CACHE_NONE;
$wgMemCachedServers = array();

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads       = false;
# use gd, as convert do not work for big image 
# see https://bugs.mageia.org/show_bug.cgi?id=3202
$wgUseImageMagick = false;
#$wgImageMagickConvertCommand = "/usr/bin/convert";

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "en_US.UTF-8";

## If you want to use image uploads under safe mode,
## create the directories images/archive, images/thumb and
## images/temp, and make them all writable. Then uncomment
## this, if it's not already uncommented:
# $wgHashedUploadDirectory = false;

## If you have the appropriate support software installed
## you can enable inline LaTeX equations:
$wgUseTeX           = false;

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
#$wgCacheDirectory = "$IP/cache";

$wgLocalInterwiki   = strtolower( $wgSitename );

$wgLanguageCode = "<%= lang %>";

$wgSecretKey = "<%= secret_key %>";

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = 'modern';

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgEnableCreativeCommonsRdf = true;
# TODO add a proper page
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "http://creativecommons.org/licenses/by-sa/3.0/";
$wgRightsText = "Creative Common - Attibution - ShareAlike 3.0";
# TODO get the icon to host it on our server
$wgRightsIcon = "http://i.creativecommons.org/l/by-sa/3.0/88x31.png";
# $wgRightsCode = "gfdl1_3"; # Not yet used

$wgDiff3 = "/usr/bin/diff3";

# When you make changes to this configuration file, this will make
# sure that cached pages are cleared.
$wgCacheEpoch = max( $wgCacheEpoch, gmdate( 'YmdHis', @filemtime( __FILE__ ) ) );

require_once 'extensions/LdapAuthentication/LdapAuthentication.php';
$wgAuth = new LdapAuthenticationPlugin();

## uncomment to debug
# $wgLDAPDebug = 10;
# $wgDebugLogGroups["ldap"] = "/tmp/wiki_ldap.log";
#
# $wgDebugLogFile = "/tmp/wiki.log";
#

$wgLDAPUseLocal = false;

$wgLDAPDomainNames = array( 'ldap');

#TODO make it workable with more than one server
$wgLDAPServerNames = array( 'ldap' => 'ldap.<%= domain %>' );
 
$wgLDAPSearchStrings = array( 'ldap' => 'uid=USER-NAME,ou=People,<%= dc_suffix %>');

$wgLDAPEncryptionType = array( 'ldap' => 'tls');

$wgLDAPBaseDNs = array( 'ldap' => '<%= dc_suffix %>');
$wgLDAPUserBaseDNs = array( 'ldap' => 'ou=People,<%= dc_suffix %>');
$wgLDAPGroupBaseDNs = array ( 'ldap' => 'ou=Group,<%= dc_suffix %>' );

$wgLDAPProxyAgent =  array( 'ldap' => 'cn=mediawiki-alamut,ou=System Accounts,<%= dc_suffix %>');
 
$wgLDAPProxyAgentPassword = array( 'ldap' => '<%= ldap_password %>' );

$wgLDAPUseLDAPGroups = array( "ldap" => true );
$wgLDAPGroupNameAttribute = array( "ldap" => "cn" );
$wgLDAPGroupUseFullDN = array( 'ldap' => true );
$wgLDAPLowerCaseUsername = array( 'ldap' => true );
$wgLDAPGroupObjectclass = array( 'ldap' => 'posixGroup' );
$wgLDAPGroupAttribute = array( 'ldap' => 'member' );

$wgLDAPLowerCaseUsername = array( "ldap" => true );

$wgLDAPPreferences = array( "ldap" => array( "email"=>"mail","realname"=>"cn","nickname"=>"uid","language"=>"preferredlanguage") );

$wgMinimalPasswordLength = 1;

<%= wiki_settings %>
