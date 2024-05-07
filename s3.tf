resource "random_string" "hash" {
  length  = 16
  special = false
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "redirect-${local.domain}-${lower(random_string.hash.result)}"

  tags = var.tags

}

resource "aws_s3_bucket_versioning" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "redirect_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.redirect_bucket,
    aws_s3_bucket_public_access_block.redirect_bucket,
  ]

  bucket = aws_s3_bucket.redirect_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "redirect_bucket" {
  bucket = aws_s3_bucket.redirect_bucket.id
  dynamic "redirect_all_requests_to" {
    for_each = var.target_url != null ? [1] : []
    content {
      host_name = var.target_url
    }
  }

  dynamic "index_document" {
    for_each = length(keys(var.remove_trailing_slash)) > 0 ? [1] : []
    content {
      suffix = "index.html"
    }
  }

  dynamic "routing_rule" {
    for_each = length(keys(var.remove_trailing_slash)) > 0 ? [1] : []
    content {
      redirect {
        host_name        = try(var.remove_trailing_slash.host_name, null)
        replace_key_with = try(var.remove_trailing_slash.replace_key_with, null)
      }
    }

  }
}