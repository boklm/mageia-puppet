class websites::start {
    include websites::base
    apache::vhost_redirect { "start.$::domain":
	url => "http://www.mageia.org/community/",
    }
}
