


resource "aws_s3_bucket" "backup_bucket" {
  bucket = "python-postgres-backup-4356656756756568454325"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.backup_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}






