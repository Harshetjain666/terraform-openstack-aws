### POST BUILD ###


#!/bin/bash
sudo su -
yum install httpd -y
systemctl enable httpd --now

