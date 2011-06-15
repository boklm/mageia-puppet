class wikis {
    include mediawiki::base

    mediawiki::instance { "en": 
        title => "Mageia wiki",
    }
}
