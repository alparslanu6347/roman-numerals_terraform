# #!/bin/bash 
# yum update -y
# yum install python3 -y
# pip3 install flask
# cd /home/ec2-user
# wget https://raw.github.com/alparslanu6347/roman-numerals_terraform/app.py
# mkdir templates
# cd templates
# wget https://raw.github.com/alparslanu6347/roman-numerals_terraform/templates/index.html
# wget https://raw.github.com/alparslanu6347/roman-numerals_terraform/templates/result.html
# cd ..
# python3 app.py  


#! /bin/bash
yum update -y
yum install python3 -y
pip3 install flask
yum install git -y
cd /home/ec2-user
wget -P templates https://raw.github.com/alparslanu6347/roman-numerals_terraform/templates/index.html
wget -P templates https://raw.github.com/alparslanu6347/roman-numerals_terraform/templates/result.html
wget https://raw.github.com/alparslanu6347/roman-numerals_terraform/app.py
python3 app.py



