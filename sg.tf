resource "aws_security_group" "main" {
  name        = "allow_ec2_${var.COMPONENT}_${var.ENV}"
  description = "allow_ec2_${var.COMPONENT}_${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description = "APP"
    from_port   = var.PORT
    to_port     = var.PORT
    protocol    = "tcp"
    cidr_blocks = [var.VPC_CIDR]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.VPC_CIDR, var.WORKSTATION_IP]
  }

  ingress {
    description = "PROMETHEUS"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.PROMETHEUS_IP]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ec2_${var.COMPONENT}_${var.ENV}"
  }
}


resource "aws_security_group" "alb" {
  name        = "allow_alb_${var.COMPONENT}_${var.ENV}"
  description = "allow_alb_${var.COMPONENT}_${var.ENV}"
  vpc_id      = var.VPC_ID

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.VPC_ACCESS_TO_ALB
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.VPC_ACCESS_TO_ALB
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_alb_${var.COMPONENT}_${var.ENV}"
  }
}
