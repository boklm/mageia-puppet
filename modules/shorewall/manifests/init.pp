class shorewall {
  include concat::setup

  $shorewalldir = "/etc/shorewall_test"

  define shorewallfile () {
     $filename = "${shorewalldir}/${name}"
     $header = "puppet:///modules/shorewall/headers/${name}"
     $footer = "puppet:///modules/shorewall/footers/${name}"
     concat{$filename:
	owner => root,
	group => root,
	mode => 600,
     }

     concat::fragment{"${name}_header":
     	target => $filename,
	order => 1,
	source => $header,
     }

     concat::fragment{"${name}_footer":
     	target => $filename,
	order => 99,
	source => $footer,
     }
  }

  ### Rules
  shorewallfile{ rules: }
  define rule_line($order = 50) {
     $filename = "${shorewalldir}/shorewall/rules"
     $line = $name
     concat::fragment{"newline_${name}":
	target => $filename,
	order => $order,
	content => $line,
     }
  }
  class allow_ssh_in {
     rule_line { "ACCEPT all all tcp 22":
     	order => 5,
     }
  }
  class allow_dns_in {
     rule_line { "ACCEPT net fw tcp 53": }
     rule_line { "ACCEPT net fw udp 53": }
  }
  class allow_smtp_in {
     rule_line { "ACCEPT net fw tcp 25": }
  }
  class allow_www_in {
     rule_line { "ACCEPT net fw tcp 80": }
  }

  ### Zones
  shorewallfile{ zones: }
  define zone_line($order = 50) {
     $filename = "${shorewalldir}/shorewall/zones"
     $line = $name
     concat::fragment{"newline_${name}":
	target => $filename,
	order => $order,
	content => $line,
     }
  }
  class default_zones {
     zone_line { "net     ipv4":
	$order => 2,
     }
     zone_line { "fw      firewall":
	$order => 3,
     }
  }

  ### Policy
  shorewallfile{ policy: }
  define policy_line($order = 50) {
     $filename = "${shorewalldir}/shorewall/policy"
     $line = $name
     concat::fragment{"newline_${name}":
	target => $filename,
	order => $order,
	content => $line,
     }
  }
  class default_policy {
     policy_line{ "fw	net	ACCEPT":
     	$order => 2,
     }
     policy_line{ "net	all	DROP	info":
     	$order => 3,
     }
     policy_line{ "all	all	REJECT	info":
     	$order => 4,
     }
  }

  class default_firewall {
     include default_zones
     include default_policy
     include allow_ssh_in
  }
}
