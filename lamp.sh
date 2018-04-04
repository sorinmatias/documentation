#!/bin/bash

#Created by Sorin Matias sorin.matias@evozon.com

#Installing selected webserver
echo -e "Installing cur yum-utils wget. Please wait..."
yum -y -q install curl yum-utils wget 2>&1>/dev/null
echo -e "Cleaning yum cache"
yum -q clean all 2>&1
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
    yum -y -q install mod_ssl openssl 2>&1>/dev/null
    yum -y install httpd
    curl https://linuxtm.ro/webservers/ |sed -n '68,137p' | sed 's/<pre>//g' |sed 's/\&lt;/</g' | sed 's/\&gt;/>/g' | sed 's/RewriteEngine/#RewriteEngine/g' | sed 's/RewriteCond/#RewriteCond/g' | sed 's/RewriteRule/#RewriteRule/g' | sed 's/^/#/' > /etc/httpd/conf.d/default.conf
    curl https://linuxtm.ro/webservers/ |sed -n '141,169p' | sed 's/<pre>//g' |sed 's/\&lt;/</g' | sed 's/\&gt;/>/g' | sed 's/^/#/' > /etc/httpd/conf.d/default-ssl.conf
    systemctl enable httpd
    systemctl start httpd
else
    echo "Installing nginx WebServer and PHP-FPM"
    yum -y install nginx
    curl https://linuxtm.ro/webservers/ | sed -n '177,265p' | sed 's/<pre>//g' |sed 's/\&lt;/</g' | sed 's/\&gt;/>/g' | sed 's/^/#/' > /etc/nginx/conf.d/default.conf
    systemctl enable nginx
    systemctl start nginx
fi

#Installing selected Mariadb
echo -e "\nWarning MariaDB 10.3 is Beta Release!\nPlease enter the desired MariaDB version (10.0 or 10.1 or 10.2 or 10.3 or enter for default 5.5)"
read ANSWER;
while [ "$ANSWER" != "" ] && [ "$ANSWER" != "10.0" ] && [ "$ANSWER" != "10.1" ] && [ "$ANSWER" != "10.2" ] && [ "$ANSWER" != "10.3" ]; do
    echo "Please enter a valid answer (10.0 or 10.1 or 10.2 or 10.3 or enter for default)"
    read ANSWER;
    echo "$ANSWER";
done
if [ "$ANSWER" == "" ];then
    ANSWER=5.5
fi
    echo "Installing $ANSWER MariaDB"
    echo -e "# MariaDB $ANSWER CentOS repository list\n# http://downloads.mariadb.org/mariadb/repositories/\n[mariadb]\nname = MariaDB\nbaseurl = http://yum.mariadb.org/$ANSWER/centos7-amd64\ngpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB\ngpgcheck=1" > /etc/yum.repos.d/MariaDB.repo
yum -y install MariaDB-client MariaDB-server
systemctl enable MariaDB
systemctl start MariaDB

#Installing selected php
echo -e "\nPlease enter the desired PHP version (5.4 or 5.5 or 5.6 or 7.0 or 7.1 or 7.2 enter for default)"
read ANSWER;
while [ "$ANSWER" != "" ] && [ "$ANSWER" != "5.4" ] && [ "$ANSWER" != "5.5" ] && [ "$ANSWER" != "5.6" ] && [ "$ANSWER" != "7.0" ] && [ "$ANSWER" != "7.1" ] && [ "$ANSWER" != "7.2" ]; do
    echo "Please enter a valid answer (5.4 or 5.5 or 5.6 or 7.0 or 7.1 or 7.2 enter for default)"
    read ANSWER;
    echo "$ANSWER";
done
if [ "$ANSWER" == "" ]; then
  ANSWER=5.4
fi
echo "Download Epel Repository"
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -O /etc/yum.repos.d/epel-release-latest-7.noarch.rpm
rpm -Uvh /etc/yum.repos.d/epel-release-latest-7.noarch.rpm
echo -e "\n\n remi \n\n"
wget http://rpms.famillecollet.com/enterprise/remi.repo -O /etc/yum.repos.d/remi.repo

yum-config-manager --disable remi-php55 remi-php56 remi-php70 remi-php71 remi-php72
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

