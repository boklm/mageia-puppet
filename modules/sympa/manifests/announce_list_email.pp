# list where announce are sent by $email only
# reply_to is set to $reply_to
define sympa::announce_list_email($subject,
                                  $reply_to,
                                  $sender_email,
                                  $language = 'en',
                                  $topics = false) {
    list { $name:
        subject      => $subject,
        profile      => '',
        language     => $language,
        topics       => $topics,
        reply_to     => $reply_to,
        sender_email => $sender_email,
    }
}
