!/bin/bash

#Created by Sorin Matias sorin.matias@evozon.com

#Installing selected webserver
WEBSERVER=0
echo -e "\nPlease select your desired webserver\nPlease enter 1 for Apache or 2 for Nginx:"
read WEBSERVER
while [ "$WEBSERVER" != "1" ] && [ "$WEBSERVER" !=  "2" ]; do
    echo "$WEBSERVER is not a valid option! Please enter 1 for Apache or 2 for Nginx"
    read WEBSERVER
done

if  [ $WEBSERVER -eq 1 ]
then
    echo "Installing Apache WebServer"
    yum -y install httpd
    systemctl enable httpd
    systemctl start httpd
else
    echo "Installing nginx WebServer and PHP-FPM"
    yum -y install nginx
    systemctl enable nginx
    systemctl start nginx
fi

#Installing selected Mariadb
MARIADEFAULT=5.5

echo -e "\nWarning MariaDB 10.3 is Beta Release!\nPlease enter the desired MariaDB version (10.0 or 10.1 or 10.2 or 10.3 or enter for default)"
read ANSWER;
while [ "$ANSWER" != "" ] && [ "$ANSWER" != "10.0" ] && [ "$ANSWER" != "10.1" ] && [ "$ANSWER" != "10.2" ] && [ "$ANSWER" != "10.3" ]; do
    echo "Please enter a valid answer (10.0 or 10.1 or 10.2 or 10.3 or enter for default)"
    read ANSWER;
    echo "$ANSWER";
done
if [ "$ANSWER" == "" ]
then
    echo "Installing default mariadb"
    echo -e "# MariaDB $MARIADEFAULT CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$MARIADEFAULT/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
    yum -y install MariaDB-server MariaDB-client
elif [ "$ANSWER" == "10.0" ];then
    echo "Installing $ANSWER mariadb"
    echo -e "# MariaDB $ANSWER CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$ANSWER/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
    yum -y install MariaDB-server MariaDB-client
elif [ "$ANSWER" == "10.1" ];then
    echo "Installing $ANSWER mariadb"
    echo -e "# MariaDB $ANSWER CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$ANSWER/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
    yum -y install MariaDB-server MariaDB-client
elif [ "$ANSWER" == "10.2" ];then
    echo "Installing $ANSWER mariadb"
    echo -e "# MariaDB $ANSWER CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$ANSWER/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
    yum -y install MariaDB-server MariaDB-client
elif [ "$ANSWER" == "10.3" ];then
    echo "Installing $ANSWER mariadb"
    echo -e "# MariaDB $ANSWER CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$ANSWER/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
    yum -y install MariaDB-server MariaDB-client
    systemctl enable mariadb
fi
systemctl start mariadb

#Installing selected php
yum -y install yum-utils wget
echo -e "\nPlease enter the desired PHP version (5.4 or 5.5 or 5.6 or 7.0 or 7.1 or 7.2 enter for default)"
read ANSWER;
while [ "$ANSWER" != "" ] && [ "$ANSWER" != "5.4" ] && [ "$ANSWER" != "5.5" ] && [ "$ANSWER" != "5.6" ] && [ "$ANSWER" != "7.0" ] && [ "$ANSWER" != "7.1" ] && [ "$ANSWER" != "7.2" ]; do
    echo "Please enter a valid answer (5.4 or 5.5 or 5.6 or 7.0 or 7.1 or 7.2 enter for default)"
    read ANSWER;
    echo "$ANSWER";
done
if ["$ANSWER" == "" ]; then
  $ANSWER=5.4
fi
echo "Download Epel Repository"
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -P /etc/yum.repos.d/
rpm -Uvh /etc/yum.repos.d/epel-release-latest-7.noarch.rpm
echo -e "\n\n remi \n\n"
wget http://rpms.famillecollet.com/enterprise/remi.repo -P /etc/yum.repos.d/

yum-config-manager --enable remi-php${ANSWER//.}
yum install -y php php-mysql
echo "Would you like to install some common PHP modules that are required by CMS Systems like Wordpress, Joomla and Drupal (y / n)"
read ANSWER;
if [ "$ANSWER" != "y" ] && [ "$ANSWER" !=  "Y" ] && [ "$ANSWER" !=  "n" ] && [ "$ANSWER" !=  "N" ]; then
    echo "Please enter a valid input (y / n)"
    read $ANSWER
fi
if [ "$ANSWER" == "y" ] && [ "$ANSWER" ==  "Y" ];then
    yum -y install php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-snmp php-soap
fi
if [ $WEBSERVER -eq 2 ];then
    yum -y install php-fpm
    systemctl start php-fpm
fi
