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