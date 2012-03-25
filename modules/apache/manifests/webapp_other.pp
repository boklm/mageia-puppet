define apache::webapp_other($webapp_file) {
    include apache::base
    $webappname = $name
    apache::config { "/etc/httpd/conf/webapps.d/$webappname.conf":
        content => template($webapp_file),
    }
}
