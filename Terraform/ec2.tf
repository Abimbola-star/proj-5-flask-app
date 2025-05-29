// ec2 instance for flask_app
resource "aws_instance" "flask_app" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t3.medium"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = file ("./scripts/flask.sh")
  tags = {
    Name = "flask_app"
  }
}

//ec2 instance for jenkins
resource "aws_instance" "jenkins" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t3.medium"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0]  
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = file("./scripts/jenkins.sh")
  tags = {
    Name = "jenkins"
  }
}

//ec2 instance for sonarqube
resource "aws_instance" "sonarqube" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t3.medium"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0]  
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = file("./scripts/sonarqube.sh")
  tags = {
    Name = "sonarqube"
  }
}

//ec2 instance for nexus
resource "aws_instance" "nexus" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t3.medium"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0]  
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = file("./scripts/nexus.sh")
  tags = {
    Name = "nexus"
  }
}


//ec2 instance for prometheus and Grafana
resource "aws_instance" "monitoring" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t3.medium"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0]  
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = file("./scripts/monitoring.sh")
  tags = {
    Name = "monitoring"
  }
}
//ec2 instance for Ansible master
resource "aws_instance" "ansible" {
  ami = "ami-0e58b56aa4d64231b"
  instance_type = "t2.micro"
  key_name = "amazonlinux.pem"
  subnet_id = module.vpc.public_subnets[0] 
  vpc_security_group_ids = [aws_security_group.proj_sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
  sudo yum -y update
  # Enable EPEL repository
  sudo amazon-linux-extras install epel
  
  # Install Ansible
  sudo yum install -y ansible
  
  # Verify installation (optional, logs to /var/log/user-data.log)
  ansible --version >> /var/log/user-data.log 2>&1
  EOF

  tags = {
    Name = "ansible"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project5-alb-sg"
  }
}

resource "aws_lb_target_group" "flask_tg" {
  name        = "flask-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "flask-target-group"
  }
}

resource "aws_lb" "flask_alb" {
  name               = "flask-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Name = "flask-app-alb"
  }
}

resource "aws_lb_listener" "flask_listener" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "flask_app" {
  target_group_arn = aws_lb_target_group.flask_tg.arn
  target_id        = aws_instance.flask_app.id
  port             = 80
}