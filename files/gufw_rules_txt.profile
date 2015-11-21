[fwBasic]
status = enabled
incoming = deny
outgoing = allow

[Rule0]
ufw_rule = 1714:1776/tcp ALLOW IN Anywhere
description = kdeconnectd
command = ufw allow in 1714:1776/tcp
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 1714:1776
iface = 
logging = 

[Rule1]
ufw_rule = 1714:1776/udp ALLOW IN Anywhere
description = kdeconnectd
command = ufw allow in 1714:1776/udp
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 1714:1776
iface = 
logging = 

[Rule2]
ufw_rule = 1714:1776/tcp (v6) ALLOW IN Anywhere (v6)
description = kdeconnectd
command = ufw allow in 1714:1776/tcp
policy = allow
direction = in
protocol = tcp
from_ip = 
from_port = 
to_ip = 
to_port = 1714:1776
iface = 
logging = 

[Rule3]
ufw_rule = 1714:1776/udp (v6) ALLOW IN Anywhere (v6)
description = kdeconnectd
command = ufw allow in 1714:1776/udp
policy = allow
direction = in
protocol = udp
from_ip = 
from_port = 
to_ip = 
to_port = 1714:1776
iface = 
logging = 

