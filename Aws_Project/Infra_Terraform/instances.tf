data "template_file" "user_data" {
  template = file("userdata.sh")
}

/*resource "aws_instance" "application_instance" {
  ami                         = "ami-0928f4202481dfdf6"
  key_name                    = "ubuntu_key"
  instance_type               = "t2.medium"
  user_data                   = data.template_file.user_data.rendered
  security_groups             = [aws_security_group.ec2.id]
  tags = {
    Name        = "application Server"
    Environment = var.env
  }
  subnet_id                   = "subnet-0f0d145c04d1b373b"
  associate_public_ip_address = true
}*/

locals {
  user_data = <<EOF
#!/bin/bash


# setup logging and begin
set -e -u -o pipefail
NOW=$(date +"%FT%T")
echo "[$NOW]  Beginning user_data script."
sudo apt update
sudo apt upgrade -y
sudo apt install -y maven
sudo apt install -y git-all
git  clone https://github.com/Ashwin-devops/Ashwin_Challenge.git
cd   Ashwin_Challenge/Aws_Project/Application_Code/
mvn clean package
sudo apt install -y docker-compose
docker-compose up
EOF
}


resource "aws_launch_configuration" "application" {
  name_prefix      = "application"
  image_id         = "ami-0928f4202481dfdf6"
  instance_type    = "t2.medium"
  key_name         = "ubuntu_key"
  user_data_base64 = base64encode(local.user_data)
  security_groups  = [aws_security_group.ec2.id]
}

resource "aws_autoscaling_group" "bar" {
  vpc_zone_identifier = aws_subnet.public_subnets.*.id
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  target_group_arns  = [ aws_lb_target_group.test.arn, aws_lb_target_group.test2.arn, aws_lb_target_group.test3.arn ]
  launch_configuration = aws_launch_configuration.application.name
  
}




