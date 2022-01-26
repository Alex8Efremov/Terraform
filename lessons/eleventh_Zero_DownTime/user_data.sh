#!/bin/bash
apt-get -y update
apt-get -y install apache2
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v1.1.3</font></h2><br>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>

<font color="magenta">
<b>Version 2.2</b>
</body>
</html>
EOF

sudo service httpd start
chkonfig httpd on
