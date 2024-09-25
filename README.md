# Gitlab Project

## Part-1 :Create gitlab project/repository `roman-numerals-converter`
- Go to gitlab

- Create gitlab project/repository
    Click `+` --> Select `New project/repository` -->> Click `Create blank project`
    `Project name` : `roman-numerals-converter`
    `Project URL`  : `https://gitlab.com/arrowlevent/roman-numerals-converter`
    `Visibility level` : `Public`
    `Project Configurations` : Put check mark on the `Initialize repository with a README`
    Click `Create project`


## Part-2 : Clone your repository to Local

```bash (Your Local : roman-numerals-converter)
git clone https://*****TOKEN*****@gitlab.com/arrowlevent/roman-numerals-converter.git
```

## Part-3 : Prepare your Application Files

1. `userdata.sh`  ***`.gitlab-ci.yml` dosyalarının hazırlanışını inceleyince userdata.sh dosyasının içeriğini daha net anlayabilirsin.***

```bash
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

# github
wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/index.html
wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/result.html
wget https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/app.py

# gitlab
# wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/index.html
# wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/result.html
# wget https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/app.py

python3 app.py
```

2. `main.tf`

```go
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "arrowlevent"       # write yours
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "arrow_roman-numerals_instance"
}

variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}


resource "aws_instance" "arrow_roman-numerals_ec2" {
  ami                         = "ami-06aa3f7caf3a30282"         # Ubuntu 20.04
  instance_type               = var.instance_type
  key_name                    = var.instance_keypair
  vpc_security_group_ids      = [aws_security_group.arrow.id]
  associate_public_ip_address = var.enable_public_ip
  subnet_id                   = "subnet-01184bdfee33d5c74"      # us-east-1a # write yours
  user_data                   = file("${path.module}/userdata.sh")
  tags = {
    Name = var.instance_name
  }
}


resource "aws_security_group" "arrow" {
  name        = "arrow-secgrp"
  description = "arrow-secgrp enable SSH-HTTP for roman-numerals project"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "arrow_roman-numerals_secgrp"
  }
}


output "roman-numerals_instance_public-ip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.arrow_roman-numerals_ec2.public_ip
}

```

3. `app.py`

```py
from flask import Flask, render_template, request

app = Flask(__name__)

# convert the given number to the roman numerals
def convert(decimal_num):
    # set the dictionary for roman numerals
    roman = {1000: 'M', 900: 'CM', 500: 'D', 400: 'CD', 100: 'C', 90: 'XC',
             50: 'L', 40: 'XL', 10: 'X', 9: 'IX', 5: 'V', 4: 'IV', 1: 'I'}
    # initialize the result variable
    num_to_roman = ''
    # loop the roman numerals, calculate for each symbol and add to the result
    for i in roman.keys():
        num_to_roman += roman[i] * (decimal_num // i)
        decimal_num %= i
    return num_to_roman

@app.route('/', methods=['POST', 'GET'])
def main_post():
    if request.method == 'POST':
        alpha = request.form['number']
        if not alpha.isdecimal():
            return render_template('index.html', developer_name='Arrow', not_valid=True)
        number = int(alpha)
        if not 0 < number < 4000:
            return render_template('index.html', developer_name='Arrow', not_valid=True)
        return render_template('result.html', number_decimal = number , number_roman= convert(number), developer_name='Arrow')
    else:
        return render_template('index.html', developer_name='Arrow', not_valid=False)

if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=80)
```

4. `templates directory, index.html & result.html`

  - `roman-numerals-converter` directory
    - templates
      - index.html
      - result.html

  - `index.html`
```html (index.html)
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Terraform Project by Arrow using GitLab CICD</title>
  <style>
    body {
      max-width: 600px;
      margin: auto;
    }

    div {
      margin-top: 100px;
      margin-bottom: 50px;
      margin-right: auto;
      margin-left: auto;
    }

    img {
      display: block;
      margin-left: auto;
      margin-right: auto;
    }

    input {
      box-sizing: border-box;
      width: 100%;
      padding: 15px;
      margin: 20px 0;
      display: inline-block;
      border: none;
      background: #f1f1f1;
    }

    button {
      box-sizing: border-box;
      background-color: #4caf50;
      color: white;
      padding: 16px 20px;
      margin: 8px 0;
      border: none;
      cursor: pointer;
      width: 100%;
      opacity: 0.9;
    }

    .warning {
      color: red;
    }

    .footnote{
      color: rgba(0, 0, 255, 0.712);
    }

  </style>
</head>

<body>

  <div><img src="https://clarusway.com/wp-content/uploads/2020/06/clarusway_logo.png" /></div>

  <h2>Project : Roman Numerals Converter Application</h2>
  <p>This application converts decimal numbers to Roman numerals. Only numbers from 1 to 3999 are allowed.</p><br>

  <form action="/" method="post">
    <label for="number"><b>Please enter a number:</b></label>
    <input placeholder="50" name="number" id="number" required />
    <button type="submit">Submit</button>
    {% if not_valid %}
    <p class="warning"><b>Not Valid! Please enter a number between 1 and 3999, inclusively.</b></p>
    {% endif %}
  </form>

  <p class="footnote"><i>This app is developed in Python by <b>Arrow</b> and deployed with Flask on AWS EC2 Instance using Terraform.</i></p>
</body>

</html>
```

  - `result.html`
```html (result.html)
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Terraform Project by Arrow using GitLab CICD</title>
    <style>
        body {
            width: 600px;
            margin: auto;
        }

        div {
            margin-top: 100px;
            margin-bottom: 50px;
            margin-right: auto;
            margin-left: auto;
        }

        img {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .result {
            color: rgb(255, 38, 0);
            font-size: x-large;
        }

        .footnote {
            color: rgba(0, 0, 255, 0.712);
        }
    </style>
</head>

<body>

    <div><img src="https://clarusway.com/wp-content/uploads/2020/06/clarusway_logo.png" /></div>

    <h2>Project : Roman Numerals Converter Application</h2>
    <br>


    <h3><b>Result:</b></h3>
    <p>Number <span class="result"> <b> {{ number_decimal }}</b> </span>equals to <span class="result"><b>{{ number_roman }}</b></span> in Roman Numerals</p><br><br>


    <p class="footnote"><i>This app is developed in Python by <b>Arrow</b> and deployed with Flask on AWS
            EC2 Instance using Terraform.</i></p>
</body>

</html>
```

5. `.gitlab-ci.yml`

- Python uygulamasını çalıştırmak için `flask` gerekiyor, içinde `python,pip` kurulu bir image buldum ve içine flask kurdum. Görüldüğü gibi uygulamanın içinde çalışacağı `GitLab Runner` için image buldum, daha sonrası için: 
      -`wget` komutu ile dosya ve klasör kopyalayacağım için,
      - `git clone` repo klonlayacağım için,
      - ilave bilgi olarak `zip, unzip` `update,upgrade` komutlarının kullanımını gösterdim.
- `cat /etc/*-release` ile işletim sistemi tabanını anladım ki kurulumlarımı yaparken dikket edeyim.

***1.version***
```yaml (.gitlab-ci.ym) 
test:
  image: python:3.9-slim-buster # bu image içinde python ve pip kurulu ama flask yok
  before_script:
    - apt-get update -y
    - apt upgrade -y
  script:
    - pwd       # /builds/arrowlevent/roman-numerals-converter     
    - ls        # README.md        
    - whoami    # root    
    - cat /etc/*-release    # PRETTY_NAME="Debian GNU/Linux 10 (buster)"
    - python3 -V            # Python 3.9.17
    - pip3 --version || apt install python3-pip -y  # pip 23.0.1 from /usr/local/lib/python3.9/site-packages/pip (python 3.9)
    - pip3 show flask || pip3 install flask         # WARNING: Package(s) not found: flask ==> installing
    - git --version || apt install git -y           # /bin/bash: line 158: git: command not found ==>> installing
    - wget --version || apt install wget -y         # /bin/bash: line 160: wget: command not found ==>> installing
```

***2.version*** BU VERSİYONDA `wget` KOMUTU İLE KENDİ `github` hesabımdaki `PUBLIC` repodan dosya-klasör kopyalayarak denedim, Runner içinde uygulama çalıştı ve GitLab dashboard üzerinde job'un terminal çıktısına bakınca çalıştığını gördüm ama sayfayı göremeyeceğim için pipeline'ı sonlandırdım. İsterseniz Gitlab repo hesabınızı da kullanabilirsiniz. Örnek içinde yorum satırı olarak mevcuttur.

- Eğer repom `PRIVATE` OLSAYDI ***`GITHUB TOKEN`*** BİLGİLERİMİ Gitlab Dasboard ÜZERİNDE ***Sensitive Variable*** OLARAK GİRMELİYDİM. O ZAMAN `wget` KOMUTLARI DA DEĞİŞİRDİ `https://$TOKEN@raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/index.html`  


```yaml (.gitlab-ci.yml)  
test:
  image: python:3.9-slim-buster # bu image içinde python ve pip kurulu ama flask yok
  before_script:
    - apt-get update -y
    - apt upgrade -y
    - zip -v || apt install zip -y
    - unzip -v || apt install unzip -y
  script:
    - pwd    
    - ls       
    - whoami    
    - cat /etc/*-release    
    - python3 -V            # Python 3.9.17
    - pip3 --version || apt install python3-pip -y  # pip 23.0.1 from /usr/local/lib/python3.9/site-packages/pip (python 3.9)
    - pip3 show flask || pip3 install flask         # WARNING: Package(s) not found: flask ==> installing
    - git --version || apt install git -y           # /bin/bash: line 158: git: command not found ==>> installing
    - wget --version || apt install wget -y         # /bin/bash: line 160: wget: command not found ==>> installing

### BURADA github REPOMU KULLANDIM   
    - wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/index.html
    - wget -P templates https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/templates/result.html
    - wget https://raw.githubusercontent.com/alparslanu6347/roman-numerals_terraform/main/app.py

### BURADA GitLab REPOMU KULLANDIM
    # - wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/index.html
    # - wget -P templates https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/templates/result.html
    # - wget https://gitlab.com/arrowlevent/roman-numerals-converter/-/raw/main/app.py

    - python3 app.py
```


***3.version***
- Deploy aşamasını AWS Cloud kullanarak yaptım. GitLab Runner için kullanacak image araştırdım, dockerhub'ta içinde terraform kurulu 2 image buldum `image: hashicorp/jsii-terraform` ve `image: devopsinfra/docker-terragrunt`, ikisi de çalışıyor. Çünkü uygulamamı `AWS , t2.micro , Ubuntu 20.04` bir makinada ayağa kaldırıyorum ve bu infrastructure'ı terraform kullanarak launch ediyorum.
  ***AWS Credentials*** BİLGİLERİMİ Gitlab Dasboard ÜZERİNDE ***Sensitive Variable*** OLARAK GİRMELİSİN.

```yaml
stages:
  - test
  - deploy

variables:
  AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION: "us-east-1"

test_app:
  stage: test
  image: python:3.9-slim-buster # bu image içinde python ve pip kurulu ama flask yok
  before_script:
  - apt-get update -y
  - apt upgrade -y
  script:
    - echo "Run your tests here , check the installations versions or install"
    - echo "I have made 'aws configure' using my credentials as sensitive variables "
    - pwd      
    - ls        
    - whoami    
    - cat /etc/*-release    # PRETTY_NAME="Debian GNU/Linux 10 (buster)"
    - python3 -V               
    - pip3 --version || apt install python3-pip -y  
    - pip3 show flask || pip3 install flask         
    - git --version || apt install git -y           
    - wget --version || apt install wget -y   
    - zip -v || apt install zip -y
    - unzip -v || apt install unzip -y         

deploy_app:
  stage: deploy
  # image: hashicorp/jsii-terraform       # Terraform v1.6.5
  image: devopsinfra/docker-terragrunt    # Terraform v1.6.6
  script:
    - echo "Deploying with Terraform"
    - terraform --version
    - terraform init
    - terraform apply -auto-approve
  # only:
  #   - main
  # environment:
  #   name: production
  # when: manual
```


```bash (Your Local : roman-numerals-converter)
ls  # README.md   templates   app.py   main.tf   userdata.sh   .gitlab-ci.yml
```
- Uygulamayı GitLab repoya gönder

```bash (Your Local : roman-numerals-converter)
git add .
git config --global user.email "alparslanu6347@gmail.com"
git config --global user.name "arrowlevent"
git commit -m "Add simple generated Docusaurus site"
git push origin     # şifre soracak -> TOKEN copy-paste enter
```

# Part-4 : Gitlab Dashboard

- Go to GitLab

- Pipeline aşamalarını/joblarını buradan gözlemleyebilirsin`Build` -- `Pipelines`
  - Job terminalde terraform output göreceksin

- Pipeline içinde değişiklik yapacaksanız `Pipeline Editor` üzerinden modifiye ettikten sonra

  - Click `Commit changes`
  - `Build` -- `Pipelines`


## Part-5 : AWS Management Console

- Go to AWS Management Console -->> `ec2-instance` ve `sec-grp` oluştuğunu gözlemle 

- uygulamayı görmek için : `http://Public IP of ec2:80`


## Resources

- https://docs.gitlab.com/

- https://gitlab.com/arrowlevent/roman-numerals-converter

- https://github.com/alparslanu6347/roman-numerals_terraform



