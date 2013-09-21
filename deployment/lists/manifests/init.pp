class lists {
    # When adding a new list, also add it to the wiki page :
    # https://wiki.mageia.org/en/Mailing_lists

    sympa::list::announce { 'announce':
        subject      => 'Mageia announces',
        reply_to     => "discuss@ml.$::domain",
        sender_email => [ "sysadmin@group.$::domain", 'ennael1@gmail.com' ],
    }

    sympa::list::announce {'atelier-bugs':
        subject      => 'Atelier bug reports from bugzilla',
        reply_to     => "atelier-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'atelier',
    }

    sympa::list::announce {'atelier-commits':
        subject      => 'Commits on atelier repositories (Artwork, Web, etc ...)',
        reply_to     => "atelier-discuss@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'atelier',
    }

    sympa::list::public {'atelier-discuss':
        subject => 'Discussions about artwork, web, marketing, communication',
        topics  => 'atelier',
    }

    sympa::list::private { 'blog-moderation':
        subject               => 'Blog comments moderation',
        subscriber_ldap_group => 'mga-blog-moderators',
        sender_email          => [ 'wordpress@blog.mageia.org' ],
        topics                => 'atelier',
    }

    sympa::list::public {'bugsquad-discuss':
        subject => 'Bugsquad team discussions',
        topics  => 'bugsquad',
    }

    sympa::list::public {'dev':
        subject => 'Developement discussion list',
        topics  => 'developers',
    }

    sympa::list::public {'discuss':
        subject => 'General discussion list',
        topics  => 'users',
    }

    sympa::list::public {'i18n-discuss':
        subject => 'Translation team discussions',
        topics  => 'i18n',
    }

    sympa::list::announce { 'i18n-bugs':
        subject      => 'Translation bug reports from bugzilla',
        reply_to     => "i18n-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'i18n',
    }

    sympa::list {'i18n-reports':
        subject           => 'Automated reports for translations',
        reply_to          => "i18n-discuss@$ml.::domain",
        sender_subscriber => true,
        sender_email      => [
            'r2d2@vargas.calenco.com',
            'blog@mageia.org',
            ],
        topics            => 'i18n',
    }

    # please check that the list use the proper code for
    # language ( not to be confused with tld or country code )
    sympa::list::public {'i18n-af':
        subject => 'Translation to Afrikaans',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-ar':
        subject => 'Translation to Arabic',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-de':
        subject => 'Translation to German',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-et':
        subject => 'Translation to Estonian',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-fr':
        subject => 'Translation to French',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-el':
        subject => 'Translation to Greek',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-nl':
        subject => 'Translation to Dutch',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-pt_br':
        subject => 'Translation to Brazilian Portuguese',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-pl':
        subject => 'Translation to Polish',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-ru':
        subject => 'Translation to Russian',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-tr':
        subject => 'Translation to Turkish',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-it':
        subject => 'Translation to Italian',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-en':
        subject => 'Translation to English',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-ro':
        subject => 'Translation to Romanian',
        topics  => 'i18n',
    }

    sympa::list::public {'i18n-zh_tw':
        subject => 'Translation to Taiwanese',
        topics  => 'i18n',
    }

    sympa::list::public {'qa-discuss':
        subject => 'Discussions about QA tasks and requests',
        topics  => 'qa',
    }

    sympa::list::announce {'qa-bugs':
        subject      => 'QA bug reports from bugzilla',
        reply_to     => "qa-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'qa',
    }

    sympa::list::announce {'qa-reports':
        subject      => 'Automated reports from QA tools',
        reply_to     => "qa-discuss@ml.$::domain",
        sender_email => [ "buildsystem-daemon@mageia.org" ],
        topics       => 'qa',
    }

    sympa::list::announce {'qa-commits':
        subject      => 'Update advisories commits',
        reply_to     => "qa-discuss@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'qa',
    }

    sympa::list::public {'forums-discuss':
        subject => 'Discuss forums matters, policies and processes, as well as publish summaries of notable events/feedback',
        topics  => 'forums',
    }

    sympa::list::announce {'forums-bugs':
        subject      => 'Forums bug reports from bugzilla',
        reply_to     => "forums-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'forums',
    }

    sympa::list::public {'doc-discuss':
        subject => 'Discussions about Mageia documentation',
        topics  => 'doc',
    }

    sympa::list::announce { 'doc-bugs':
        subject      => 'Documentation bug reports from bugzilla',
        reply_to     => "doc-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'doc',
    }

    sympa::list::announce { 'packages-commits':
        subject      => 'Commits on packages repository',
        reply_to     => "dev@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'developers',
    }

    sympa::list::announce { 'mirrors-announce':
        subject      => 'Important announces about mirrors updates',
        reply_to     => "sysadmin-discuss@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'sysadmin',
    }

    sympa::list::announce {'sysadmin-commits':
        subject      => 'Commits on sysadmin repository',
        reply_to     => "sysadmin-discuss@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'sysadmin',
    }

    sympa::list::public {'sysadmin-discuss':
        subject      => 'Sysadmin team discussions',
        topics       => 'sysadmin',
    }

    sympa::list::announce {'sysadmin-reports':
        subject      => 'Automated reports from various pieces of infrastructure',
        reply_to     => "sysadmin-discuss@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'sysadmin',
    }

    sympa::list::announce { 'sysadmin-bugs':
        subject      => 'Sysadmin bug reports from bugzilla',
        reply_to     => "sysadmin-discuss@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'sysadmin',
    }

    sympa::list::announce { 'soft-commits':
        subject      => 'Commits on soft repository',
        reply_to     => "dev@ml.$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'developers',
    }

    sympa::list::announce { 'bugs':
        subject      => 'Bug reports from bugzilla',
        reply_to     => "dev@ml.$::domain",
        sender_email => [ "bugzilla-daemon@$::domain" ],
        topics       => 'developers',
    }

    sympa::list::announce { 'updates-announce':
        subject      => 'Packages update for stable release',
        reply_to     => "dev@ml.$::domain",
        sender_email => [ "buildsystem-daemon@$::domain" ],
        topics       => 'developers',
    }

    sympa::list::announce { 'changelog':
        subject      => 'Announces for new packages uploaded',
        reply_to     => "dev@ml.$::domain",
        sender_email => [ "buildsystem-daemon@$::domain" ],
        topics       => 'developers',
    }

    sympa::list::announce { 'board-commits':
        subject               => 'Commits on Mageia.Org status and organisation documents',
        reply_to              => "board-public@ml.$::domain",
        sender_email          => [ "root@$::domain" ],
        topics                => 'governance',
        subscriber_ldap_group => 'mga-board',
    }

    sympa::list::public_restricted { 'board-public':
        subject               => 'Public board discussion',
        subscriber_ldap_group => 'mga-board',
        topics                => 'governance',
    }

    sympa::list::private { 'board-private':
        subject               => 'Private board discussion',
        subscriber_ldap_group => 'mga-board',
        topics                => 'governance',
    }

    sympa::list::announce {'treasurer-commits':
        subject      => 'Commits on Mageia.Org association treasurer repository',
        reply_to     => "treasurer@$::domain",
        sender_email => [ "root@$::domain" ],
        topics       => 'governance',
    }

    sympa::list::public_restricted { 'council':
        subject               => 'Council discussions',
        subscriber_ldap_group => 'mga-council',
        topics                => 'governance',
    }

    sympa::list::public {'local-discuss':
        subject => 'Discussions about Local Community Team',
        topics  => 'local',
    }

    sympa::list::public {'discuss-fr':
        subject => 'French discussions about Mageia',
        topics  => 'users',
    }

    sympa::list::public {'discuss-pt-br':
        subject => 'Discussions about Mageia in Brazilian Portuguese',
        topics  => 'users',
    }
}

