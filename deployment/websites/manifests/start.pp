class websites::start {
    include websites::base
    apache::vhost_redirect { "sart.$::domain":
	url => "http://www.mageia.org/community/",
    }
}
