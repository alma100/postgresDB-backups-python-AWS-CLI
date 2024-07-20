# Az IAM felhasználó létrehozása
resource "aws_iam_user" "python_s3_fullaccess" {
  name = "python_s3_fullaccess"
  path = "/s3-data/"
}


resource "aws_iam_access_key" "python_s3_fullaccess" {
  user = aws_iam_user.python_s3_fullaccess.name
}

# Az IAM policy létrehozása
data "aws_iam_policy_document" "s3_full_access" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }
}

# Az IAM policy hozzárendelése az IAM felhasználóhoz
resource "aws_iam_user_policy" "s3_full_access" {
  name   = "s3_full_access"
  user   = aws_iam_user.python_s3_fullaccess.name
  policy = data.aws_iam_policy_document.s3_full_access.json
}

resource "local_file" "aws_credentials" {
  content  = <<EOT
[default]
aws_access_key_id = ${aws_iam_access_key.python_s3_fullaccess.id}
aws_secret_access_key = ${aws_iam_access_key.python_s3_fullaccess.secret}
region = us-east-1
EOT
  filename = "aws_credentials"
}


resource "aws_s3_bucket" "backup_bucket" {
  bucket = "python-psotgre-backup-4356656756756568454325"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.backup_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

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

resource "aws_key_pair" "database_key" {
  key_name   = "database-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqHBWLjLIIu5mWdsyUTS9/sXpzA+z1wI0VrRMukNPwK70Vth81Assl6ZsqI/reliE20odwanwGHOQHuH0n2Z8AS5B0wsHz+A6LKWeWHL4r1tPkW/J26w/2NJPHvMg4UBNJnx+e7vSffH31EzP5HqHq3fun2GI9dOyA6Npc02SX7Bw3ddB+jVEkGDWmyRd1WO/HhXbs8t4DtNCBtxEr3wy5pa1SekbNWJxrnLvb3BwTl0VwWiV6iu9zo680QC9VdSZY43bOs0JdRjdOKekWn27Eio2fqgPZ+3DTOWSQcG/k9gH0+VteyfXqidlBKR+l1haspCxPelM9vQe9gd3OPXDHlph1lCYAs8qBhDxMli8JNMNRDwBlSeHIZapCeq2BQnK/9mPIJGH6zs5YVrQ3wpv5mBeRqMhCzU/BCDR4jcxe4d/yf7HZRWXe6GgfA9MvlpdJl/DHHEPN9dMALwCrebn0tJ9MOsLDZgqXifgzvrHg3QmbPRu0TNdnvjAZYUJkeSE= aba@ab.test"
}

resource "aws_instance" "database" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.small"
  key_name = aws_key_pair.database_key.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = <<-EOF
    #!/bin/bash
              
    chmod +x /db-setup/db-setup.sh
    /db-setup/db-setup.sh
    EOF
}

