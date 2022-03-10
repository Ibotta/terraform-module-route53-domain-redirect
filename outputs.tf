output "cloudfront_distribution" {
    description = "AWS cloudfront distribution"
    value = aws_cloudfront_distribution.redirect
}

output "s3_bucket" {
    description = "AWS S3 Bucket"
    value = aws_s3_bucket.redirect_bucket
}

output "acm_cert" {
  description = "AWS ACM Certificate"
  value = aws_acm_certificate.cert
}