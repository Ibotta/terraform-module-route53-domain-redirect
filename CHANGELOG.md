## Changelog

### `1.2.8`

- Add variable `remove_trailing_slash` to allow removing trailing slash automicatically added by S3 to the target URL.

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
