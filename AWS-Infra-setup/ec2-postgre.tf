data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "this" {
  name        = "allow-ssh-only"
  description = "Security group that allow ssh only"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "database" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.small"
  key_name = aws_key_pair.database_key.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "database"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum upgrade -y
    sudo yum install -y docker

    sudo systemctl start docker
    sudo systemctl enable docker

    sudo usermod -a -G docker ec2-user

    sudo docker run -d \
      --name postgres \
      -e POSTGRES_USER=admin \
      -e POSTGRES_PASSWORD=admin \
      -e POSTGRES_DB=sample \
      -p 80:5432 \
      -p 5432:5432 \
      --restart always \
      postgres:9.6.8-alpine
  EOF
}