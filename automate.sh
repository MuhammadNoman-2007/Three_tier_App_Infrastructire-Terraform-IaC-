#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
if [ ${1} == "frontend" ]; then
  echo "<h1>Welcome to the Frontend Server</h1>" | sudo tee /var/www/html/index.html
elif [ ${1} == "backend" ]; then
  echo "<h1>Welcome to the Backend Server</h1>" | sudo tee /var/www/html/index.html
elif [ ${1} == "database" ]; then
  echo "<h1>Welcome to the Database Server</h1>" | sudo tee /var/www/html/index.html
else
  echo "<h1>Unknown Server Type</h1>" | sudo tee /var/www/html/index.html
fi