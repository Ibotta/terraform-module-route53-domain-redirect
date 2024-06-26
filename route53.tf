data "aws_route53_zone" "zone" {
  name = var.zone
}

resource "aws_route53_record" "redirect" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.redirect_to_subdomain ? var.source_subdomain : data.aws_route53_zone.zone.name
  type    = "A"

  allow_overwrite = var.allow_overwrite

  alias {
    name                   = aws_cloudfront_distribution.redirect.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect-www" {
  count   = local.redirect_to_subdomain ? 0 : 1
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "www.${data.aws_route53_zone.zone.name}"
  type    = "A"

  allow_overwrite = var.allow_overwrite

  alias {
    name                   = aws_cloudfront_distribution.redirect.domain_name
    zone_id                = aws_cloudfront_distribution.redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  # https://github.com/hashicorp/terraform-provider-aws/issues/10098#issuecomment-663562342
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 60
}
