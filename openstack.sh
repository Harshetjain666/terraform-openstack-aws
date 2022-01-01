#!/bin/bash

cat /etc/passwd | grep stack &> /dev/null
if [ $? == 0 ] ; then
    echo -e " \xE2\x9C\x85 Stack user exist"
else
    sudo useradd -s /bin/bash -d /opt/stack -m stack
    if [ $? == 0 ] ; then
         echo -e " \xE2\x9C\x85 Stack user created"
    else
         echo -e " \xE2\x9D\x8C Error creating user"
         exit
    fi
fi
if [ -d /tmp/stack ] ; then
    echo -e " \xE2\x9C\x85 Permission already updated"
else
    echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack > /dev/null
    if [ $? == 0 ] ; then
         echo -e " \xE2\x9C\x85 Stack user permission updated"
         sudo -u stack  mkdir -p /tmp/stack
    else
         echo -e " \xE2\x9D\x8C Error setting up permissions"
         exit
    fi
fi
#sudo apt-get install -y git-core &> /dev/null
#if [ $? == 0 ] ; then
#    echo -e " \xE2\x9C\x85 Requirement installed"
#else
#    echo -e " \xE2\x9D\x8C Error installing requirements"
#    exit
#fi
if [ -d /opt/stack/devstack ] ; then
    echo -e " \xE2\x9C\x85 Code exist"
else
    if [ -z $1 ] ; then
          sudo -H -u stack git clone https://git.openstack.org/openstack-dev/devstack -b stable/rocky  /opt/stack/devstack  &> /dev/null
          if [ $? == 0 ] ; then
                 echo -e " \xE2\x9C\x85 Code Downloaded"
          else
                 echo -e " \xE2\x9D\x8C Error downloading code \nPossible reasons: \n1. Git cmd not installed \n2. Not stable internet connection"
                 exit
          fi
    else
          sudo -H -u stack git clone https://git.openstack.org/openstack-dev/devstack -b stable/$1  /opt/stack/devstack  &> /dev/null
          if [ $? == 0 ] ; then
                 echo -e " \xE2\x9C\x85 Code Downloaded"
          else
                 echo -e " \xE2\x9D\x8C Error downloading code \nPossible reasons: \n1. Make sure you typed the write version \n2. Git cmd not installed \n3. Not stable internet connection"
                 exit
          fi
    fi
fi

# grep host ip
export HOST_IP=`hostname -I | awk '{print $1}'`


if ( test -f /opt/stack/devstack/local.conf ) ; then
    echo -e " \xE2\x9C\x85 Config file exist"
else
    sudo -H -u stack cp -f /opt/stack/devstack/samples/local.conf /opt/stack/devstack/
    echo -e " \xE2\x9C\x85 Config file created"
    
    # edit in local.conf file
    sudo -H  -u stack sed -i "s/#HOST_IP=w.x.y.z/HOST_IP=$HOST_IP/g" /opt/stack/devstack/local.conf
fi    
sleep 2
# Openstack installation cmd
#sudo -u stack /opt/stack/devstack/stack.sh
a() {
#su -c '/opt/stack/devstack/stack.sh &> /dev/null' stack
sudo -H -u stack /opt/stack/devstack/stack.sh &> /dev/null 
}
a &
PID=$!
#SC=$?
#echo $PID
#USER=`whoami`
#process_id=`/bin/ps -fu $USER| grep "openstack.sh" | grep -v "grep" | awk '{print $2}'`
#PID=`echo $process_id | awk '{print $2}'`
echo -e "\nTHIS MAY TAKE A WHILE, PLEASE BE PATIENT WHILE OPENSTACK IS INSTALLING..."
printf "[ "
# While process is running...
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 14
done
wait $PID
SC=$?
printf " ]"
if [ $SC == 0 ] ; then
    echo -e "\n\n \xE2\x9C\x85 Openstack installed successfully"
else
    echo -e " \xE2\x9D\x8C Error installing Openstack"
    exit
fi
if [ -z $1 ] ; then
    echo -e "\nOpenstack Version: rocky"
else
    echo -e "\nOpenStack Version: $1"
fi
echo "Horizon is now available at http://$HOST_IP/dashboard"
echo "Keystone is serving at http://$HOST_IP/identity/"
echo "The default users are: admin and demo"
sudo -H -u stack echo -e "The password: `cat /opt/stack/devstack/local.conf | grep ADMIN_PASSWORD | awk 'NR==1{print $1}' |  cut -d "=" -f2`\n"
