class forums {

    phpbb::instance { "en": }

    phpbb::instance { "de": }

    phpbb:redirection_instance{ "fr":
       url => "https://forums.mageia.org/en/viewforum.php?f=19"
    }
}
