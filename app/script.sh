#!/bin/sh

myip=$(curl  http://169.254.170.2/v2/metadata | jq .Containers[0].Networks[0].IPv4Addresses[0] )
myavzone=$(curl  http://169.254.170.2/v2/metadata | jq .AvailabilityZone )
echo "Hello! from terraform  ip is $myip avZone is $myavzone"  >/var/www/localhost/htdocs/index.html

/usr/sbin/httpd -D FOREGROUND
