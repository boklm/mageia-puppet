class websites::forum_proxy {
    $web_domain = "forums.$::domain"

    apache::vhost::reverse_proxy { $web_domain:
        url => "http://$web_domain/",
    }

    apache::vhost::reverse_proxy { "ssl_$web_domain":
        vhost   => $web_domain,
        use_ssl => true,
        url     => "http://$web_domain/",
    }
}
