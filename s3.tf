resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${var.zone}-${lower(random_string.hash.result)}"

}

resource "aws_s3_bucket_acl" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  acl = "private"

}

resource "aws_s3_bucket_website_configuration" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  redirect_all_requests_to {
    host_name = var.target_url
  }

}
resource "aws_s3_bucket_public_access_block" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}