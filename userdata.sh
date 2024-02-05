#! /bin/bash

apt-get update -y
apt upgrade -y
zip -v || apt install zip -y
unzip -v || apt install unzip -y
pip3 --version || apt install python3-pip -y
pip3 show flask || pip3 install flask
git --version || apt install git -y
wget --version || apt install wget -y 
cd /home/ubuntu

# Burada github repomu kullandım
wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/index.html
wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/result.html
wget https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/app.py

# BURADA gitlab REPOMU KULLANDIM
# wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/index.html
# wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/result.html
# wget https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/app.py

python3 app.py


##### gitlab / github
