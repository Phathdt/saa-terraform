provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "S3 cloudfront"
}

data "template_file" "json_policy" {
  template = file("policy.json")
  vars = {
    domain  = var.domain
    iam_arn = aws_cloudfront_origin_access_identity.default.iam_arn
  }
}
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.domain
  acl    = "private"
  policy = data.template_file.json_policy.rendered

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "s3_object" {
  for_each = fileset(path.module, "web_bucket/**/*")

  bucket = aws_s3_bucket.web_bucket.id
  key    = replace(each.value, "web_bucket", "./")
  source = each.value
}

resource "aws_s3_bucket_object" "s3_object_html" {
  for_each = fileset(path.module, "web_bucket/*.html")

  bucket       = aws_s3_bucket.web_bucket.id
  key          = replace(each.value, "web_bucket", "./")
  source       = each.value
  content_type = "text/html"
}

resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = var.domain
    domain_name = "${var.domain}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  # If using route53 aliases for DNS we need to declare it here too, otherwise we'll get 403s.
  aliases = [var.domain]

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.domain

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 120
    max_ttl                = 240
  }

  # The cheapest priceclass
  price_class = "PriceClass_100"

  # This is required to be specified even if it's not used.
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:322124301799:certificate/ab8ef963-11c2-4e8f-8a2d-ec095b540cfd"
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }
}
