### POST BUILD ###

#!/bin/bash


sudo yum install httpd -y
sudo systemctl enable httpd --now
sudo cat << EOF > /var/wwww/html/index.html
<body bgcolor = "#E0FFFF" >
<h1>WELCOME TO THE AUTOMATION WORLD</h1>
<h3>THIS IS TESTING PAGE!!!</h3>
</body>
<img src='url' width=200 height=200 />
EOF
