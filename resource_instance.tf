resource "aws_instance" "arrow_roman-numerals_ec2" {
  ami           = "ami-006dcf34c09e50022"   # Amazon linux 2
  instance_type = var.instance_type
  key_name      = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.arrow.id ]
  associate_public_ip_address = var.enable_public_ip
  subnet_id = "subnet-069d7f45d2659c70c" ## us-east-1a
  user_data = file("${path.module}/arrow_userdata.sh") 
  tags = {
    Name = var.instance_name
  }
}