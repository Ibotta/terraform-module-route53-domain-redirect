resource "aws_cloudfront_distribution" "redirect" {
  origin {
    domain_name = "${aws_s3_bucket.redirect_bucket.bucket}.s3-website.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = aws_s3_bucket.redirect_bucket.bucket

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  price_class     = "PriceClass_100"
  comment         = aws_s3_bucket.redirect_bucket.bucket
  enabled         = true
  is_ipv6_enabled = false

  aliases = local.redirect_to_subdomain ? [var.source_subdomain] : ["www.${var.zone}", var.zone]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.redirect_bucket.bucket
    compress         = true

    min_ttl     = 31536000
    max_ttl     = 31536000
    default_ttl = 31536000

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  tags = var.tags

  wait_for_deployment = false
  depends_on          = [aws_acm_certificate_validation.validation]

  lifecycle {
    ignore_changes = [web_acl_id]
  }
}
