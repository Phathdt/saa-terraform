provider "aws" {
  region = "ap-southeast-1"
}
data "template_file" "json_policy" {
  template = file("policy.json")
  vars = {
    domain = var.domain
  }
}
resource "aws_s3_bucket" "web_bucket" {
  bucket = var.domain
  acl    = "public-read"
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
