#!/bin/bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
if [ ${1} == "frontend" ]; then
  echo "<h1>Welcome to the Frontend Server</h1>" | sudo tee /var/www/html/index.html
