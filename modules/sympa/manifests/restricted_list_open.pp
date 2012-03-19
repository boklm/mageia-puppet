# same as restricted list, but anybody can post
define sympa::restricted_list_open( $subject,
                                    $subscriber_ldap_group,
                                    $language = 'en',
                                    $topics = false) {
    list { $name:
        subject               => $subject,
        profile               => '',
        language              => $language,
        topics                => $topics,
        subscriber_ldap_group => $subscriber_ldap_group,
        sender_ldap_group     => $subscriber_ldap_group,
    }
}
