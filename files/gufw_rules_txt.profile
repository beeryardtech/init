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
ufw_rule = 9511 ALLOW IN Anywhere
description = urserver-discovery
command = ufw allow in 9511
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9511
iface = 
logging = 

[Rule3]
ufw_rule = 9512 ALLOW IN Anywhere
description = urserver
command = ufw allow in 9512
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9512
iface = 
logging = 

[Rule4]
ufw_rule = 9443 ALLOW IN Anywhere
description = grunt server
command = ufw allow in 9443
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9443
iface = 
logging = 

[Rule5]
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

[Rule6]
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

[Rule7]
ufw_rule = 9511 (v6) ALLOW IN Anywhere (v6)
description = urserver-discovery
command = ufw allow in 9511
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9511
iface = 
logging = 

[Rule8]
ufw_rule = 9512 (v6) ALLOW IN Anywhere (v6)
description = urserver
command = ufw allow in 9512
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9512
iface = 
logging = 

[Rule9]
ufw_rule = 9443 (v6) ALLOW IN Anywhere (v6)
description = grunt server
command = ufw allow in 9443
policy = allow
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 9443
iface = 
logging = 

