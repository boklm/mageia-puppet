# public discussion list
# reply_to is set to the list
define sympa::list::public($subject,
                          $language = 'en',
                          $topics = false) {
    include sympa::variable
    list { $name:
        subject                 => $subject,
        language                => $language,
        topics                  => $topics,
        sender_subscriber       => true,
        reply_to                => "$name@$sympa::variable::vhost",
    }
}
