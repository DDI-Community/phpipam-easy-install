#!/bin/bash

set -e

# === CONFIG ===
DB_NAME="phpipam"
DB_USER="phpipam"
DB_PASS="phpipam_pass"
WEB_ROOT="/var/www/html"

echo "== 📦 Updating system =="
apt update && apt upgrade -y

echo "== 📥 Installing dependencies =="
apt install -y apache2 mariadb-server php php-mysql php-gmp php-ldap php-cli php-json php-curl php-mbstring php-xml php-gd php-pear git unzip fping nmap ipcalc

echo "== 🗄️ Setting up MySQL database and user =="
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "== 🌐 Deploying phpIPAM to web root =="
cd $WEB_ROOT
rm -rf ./*
git clone https://github.com/phpipam/phpipam.git temp_ipam
shopt -s dotglob
mv temp_ipam/* ./
rm -rf temp_ipam
shopt -u dotglob
chown -R www-data:www-data $WEB_ROOT

echo "== 🧰 Configuring phpIPAM =="
cp config.dist.php config.php
sed -i "s/'host'.*/'host'] = 'localhost';/" config.php
sed -i "s/'user'.*/'user'] = '$DB_USER';/" config.php
sed -i "s/'pass'.*/'pass'] = '$DB_PASS';/" config.php
sed -i "s/'name'.*/'name'] = '$DB_NAME';/" config.php

echo "== ⚙️ Setting up Apache =="
cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot $WEB_ROOT
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2enmod rewrite
systemctl restart apache2

echo "== 🔍 Enabling IP discovery tools =="
chmod +s /usr/bin/fping
chmod +s /usr/bin/nmap

echo ""
echo "======================================================================"
echo " ✅ phpIPAM installed at: http://<your-container-IP>"
echo " 🔐 MySQL user:     $DB_USER"
echo "     MySQL pass:    $DB_PASS"
echo ""
echo " 👉 In the web installer, select 'New phpIPAM Installation'"
echo " 🔽 Then on the DB config screen:"
echo "    🔲 Drop existing database"
echo "    🔲 Create new database"
echo "    🔲 Set permissions to tables"
echo ""
echo " ✅ Just enter the DB credentials and proceed!"
echo "======================================================================"
