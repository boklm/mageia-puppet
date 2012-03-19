# list with private archive, restricted to member of $ldap_group
define sympa::list::private($subject,
                            $subscriber_ldap_group,
                            $language ='en',
                            $topics = false) {
    list { $name:
        subject               => $subject,
        profile               => '',
        language              => $language,
        topics                => $topics,
        subscriber_ldap_group => $subscriber_ldap_group,
        sender_ldap_group     => $subscriber_ldap_group,
        public_archive        => false,
    }
}
