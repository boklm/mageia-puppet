# list with private archive, restricted to member of $ldap_group
define sympa::list::private($subject,
                            $subscriber_ldap_group,
                            $sender_email = '',
                            $language ='en',
                            $topics = false) {
    list { $name:
        subject               => $subject,
        language              => $language,
        topics                => $topics,
        subscriber_ldap_group => $subscriber_ldap_group,
        sender_ldap_group     => $subscriber_ldap_group,
        sender_email          => $sender_email,
        public_archive        => false,
    }
}
