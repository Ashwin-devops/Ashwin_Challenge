#!/bin/bash


# setup logging and begin
set -e -u -o pipefail
NOW=$(date +"%FT%T")
echo "[$NOW]  Beginning user_data script."
sudo apt update
sudo apt upgrade -y
sudo apt install -y maven
sudo apt install -y git-all
git clone https://github.com/Ashwin-devops/Ashwin_Challenge.git
cd  Ashwin_Challenge/Aws_Project/Application_Code/
mvn clean package
sudo apt install -y docker-compose
docker-compose up
