data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_security_group" "this" {
  name        = "allow-ssh-and-sql"
  description = "Security group that allow ssh and sql only"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}


resource "aws_instance" "database" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.small"
  key_name = aws_key_pair.database_key.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "database"
  }
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum upgrade -y
    sudo yum install amazon-ssm-agent -y
    sudo yum install -y docker

    sudo service amazon-ssm-agent start
    sudo systemctl start docker
    sudo systemctl enable docker

    sudo usermod -a -G docker ec2-user

    docker run -d \
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