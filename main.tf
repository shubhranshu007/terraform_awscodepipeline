#provider "aws" {
  region = "us-east-1"
}

# security-group.tf
resource "aws_security_group" "this" {
  name        = "my-security-group"
  description = "Security group managed by Terraform"
  vpc_id      = "vpc-0351cf03f93ffe57a" 

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict to your IP in production
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "my-security-group"
    ManagedBy = "terraform"
  }
}

output "security_group_id" {
  value = aws_security_group.this.id
}
