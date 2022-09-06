resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${local.domain}-${lower(random_string.hash.result)}"

}

resource "aws_s3_bucket_acl" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  acl = "public-read"

}

resource "aws_s3_bucket_website_configuration" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  redirect_all_requests_to {
    host_name = var.target_url
  }

}