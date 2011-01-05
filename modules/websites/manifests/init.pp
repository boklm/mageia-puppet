class websites {
    # should expire on June 2011
    class donate {
        apache::vhost_other_app { "donate.$domain":
            vhost_file => "websites/vhost_donate.conf",
        }
    }
}
