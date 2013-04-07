class lists {
    sympa::announce_list_email { 'announce':
        subject      => 'Mageia announces',
        reply_to     => "discuss@ml.$::domain",
        sender_email => "sysadmin@group.$::domain",
    }

    sympa::public_list {'atelier-discuss':
        subject => 'Discussions about artwork, web, marketing, communication',
        topics  => 'atelier',
    }

    sympa::public_list {'bugsquad-discuss':
        subject => 'Bugsquad team discussions',
        topics  => 'bugsquad',
    }

    sympa::public_list {'dev':
        subject => 'Developement discussion list',
        topics  => 'developers',
    }

    sympa::public_list {'discuss':
        subject => 'General discussion list',
    }

    sympa::public_list {'i18n-discuss':
        subject => 'Translation team discussions',
        topics  => 'i18n',
    }

    sympa::announce_list_email { 'i18n-bugs':
        subject      => 'Translation bug reports from bugzilla',
        reply_to     => "i18n-discuss@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'i18n',
    }

    sympa::announce_list_email {'i18n-reports':
        subject      => 'Automated reports for translations',
        reply_to     => "i18n-discuss@$ml.::domain",
        sender_email => 'r2d2@vargas.calenco.com',
        topics       => 'i18n',
    }

    # please check that the list use the proper code for
    # language ( not to be confused with tld or country code )
    sympa::public_list {'i18n-af':
        subject => 'Translation to Afrikaans',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-de':
        subject => 'Translation to German',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-et':
        subject => 'Translation to Estonian',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-fr':
        subject => 'Translation to French',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-el':
        subject => 'Translation to Greek',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-nl':
        subject => 'Translation to Dutch',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-pt_br':
        subject => 'Translation to Brazilian Portuguese',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-pl':
        subject => 'Translation to Polish',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-ru':
        subject => 'Translation to Russian',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-tr':
        subject => 'Translation to Turkish',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-it':
        subject => 'Translation to Italian',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-en':
        subject => 'Translation to English',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-ro':
        subject => 'Translation to Romanian',
        topics  => 'i18n',
    }

    sympa::public_list {'i18n-zh_tw':
        subject => 'Translation to Taiwanese',
        topics  => 'i18n',
    }

    sympa::public_list {'qa-discuss':
        subject => 'Discussions about QA tasks and requests',
        topics  => 'qa',
    }

    sympa::announce_list_email {'qa-bugs':
        subject      => 'QA bug reports from bugzilla',
        reply_to     => "qa-discuss@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'qa',
    }

    sympa::public_list {'forums-discuss':
        subject => 'Discuss forums matters, policies and processes, as well as publish summaries of notable events/feedback',
        topics  => 'forums',
    }

    sympa::announce_list_email {'forums-bugs':
        subject      => 'Forums bug reports from bugzilla',
        reply_to     => "forums-discuss@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'forums',
    }

    sympa::public_list {'doc-discuss':
        subject => 'Discussions about Mageia documentation',
        topics  => 'doc',
    }

    sympa::announce_list_email { 'doc-bugs':
        subject      => 'Documentation bug reports from bugzilla',
        reply_to     => "doc-discuss@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'doc',
    }

    sympa::announce_list_email { 'packages-commits':
        subject      => 'Commits on packages repository',
        reply_to     => "dev@ml.$::domain",
        sender_email => "root@$::domain",
        topics       => 'developers',
    }

    sympa::announce_list_email { 'mirrors-announce':
        subject      => 'Important announces about mirrors updates',
        reply_to     => "sysadm-discuss@ml.$::domain",
        sender_email => "root@$::domain",
        topics       => 'sysadmin',
    }

    sympa::announce_list_email {'sysadmin-commits':
        subject      => 'Commits on sysadmin repository',
        reply_to     => "sysadm-discuss@ml.$::domain",
        sender_email => "root@$::domain",
        topics       => 'sysadmin',
    }

    sympa::public_list {'sysadmin-discuss':
        subject      => 'Sysadmin team discussions',
        topics       => 'sysadmin',
    }

    sympa::announce_list_email {'sysadmin-reports':
        subject      => 'Automated reports from various pieces of infrastructure',
        reply_to     => "sysadm-discuss@ml.$::domain",
        sender_email => "root@$::domain",
        topics       => 'sysadmin',
    }

    sympa::announce_list_email { 'sysadmin-bugs':
        subject      => 'Sysadmin bug reports from bugzilla',
        reply_to     => "sysadm-discuss@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'sysadmin',
    }

    sympa::announce_list_email { 'soft-commits':
        subject      => 'Commits on soft repository',
        reply_to     => "dev@ml.$::domain",
        sender_email => "root@$::domain",
        topics       => 'developers',
    }

    sympa::announce_list_email { 'bugs':
        subject      => 'Bug reports from bugzilla',
        reply_to     => "dev@ml.$::domain",
        sender_email => "bugzilla-daemon@$::domain",
        topics       => 'developers',
    }

    sympa::announce_list_email { 'updates-announce':
        subject      => 'Packages update for stable release',
        reply_to     => "dev@ml.$::domain",
        sender_email => "buildsystem-daemon@$::domain",
        topics       => 'developers',
    }

    sympa::announce_list_email { 'changelog':
        subject      => 'Announces for new packages uploaded',
        reply_to     => "dev@ml.$::domain",
        sender_email => "buildsystem-daemon@$::domain",
        topics       => 'developers',
    }

    sympa::announce_list_email { 'board-commits':
        subject               => 'Commits on Mageia.Org status and organisation documents',
        reply_to              => "board-public@ml.$::domain",
        sender_email          => "root@$::domain",
        topics                => 'governance',
        subscriber_ldap_group => 'mga-board',
    }

    sympa::public_restricted_list { 'board-public':
        subject               => 'Public board discussion',
        subscriber_ldap_group => 'mga-board',
        topics                => 'governance',
    }

    sympa::list::private { 'board-private':
        subject               => 'Private board discussion',
        subscriber_ldap_group => 'mga-board',
        topics                => 'governance',
    }

    sympa::public_restricted_list { 'council':
        subject               => 'Council discussions',
        subscriber_ldap_group => 'mga-council',
        topics                => 'governance',
    }

    sympa::public_list {'local-discuss':
        subject => 'Discussions about Local Community Team',
        topics  => 'local',
    }
}
