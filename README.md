# Route53 Domain Redirect

![Diagram](domain-redirect-diagram.png)

This Terraform module works together with AWS Route53, S3, ACM and CloudFront to create permanent redirect of a domain to a target URL.

Both www and apex A records are created and pointed to a CloudFront distribution. The distribution accepts HTTP and HTTPS connections (free autorenewing ACM certificate is used for HTTPS). The origin for CloudFront distribution is a S3 hosted website with redirect-all rule. This solution is cheap and maintenance free.

**Requirements:** DNS Zone in Route53

## To Deploy

Please review our [Contributing docs](./.github/CONTRIBUTING.md) for the review and release process.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.redirect-www](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.redirect_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [random_string.hash](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Route53 zone name | `string` | n/a | yes |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow route53 to overwrite the current rule | `bool` | `false` | no |
| <a name="input_remove_trailing_slash"></a> [remove\_trailing\_slash](#input\_remove\_trailing\_slash) | Remove trailing slash automatically added by S3 to the target URL. Conflicts with target\_url. | `map(string)` | `{}` | no |
| <a name="input_source_subdomain"></a> [source\_subdomain](#input\_source\_subdomain) | FQDN of subdomain that we want to redirect from. | `string` | `""` | no |
| <a name="input_target_url"></a> [target\_url](#input\_target\_url) | URL to redirect to | `string` | `null` | no |

## Outputs

No outputs.

## Changelog

### `1.2.8`

- Add variable `remove_trailing_slash` to allow removing trailing slash automatically added by S3 to the target URL.

### `1.2.7`

- specify minimum SSL protocol as `TLSv1.2_2021`

### `1.2.6`

- ignore `web_acl_id` in Cloudfront
- add github action for formatting terraform and docs

### `1.2.5`

- Move s3 website configuration to it's own resource `aws_s3_bucket_website_configuration`.
- Block S3 public access and set bucket ACL to `private`.
- Add tags to `aws_cloudfront_distribution`.

### `1.2.4`

- Add `aws_s3_bucket_versioning`, and tag s3 buckets per org guidelines.
