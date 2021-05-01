provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = "www.kanesa.xyz"
  acl    = "public-read"
  policy = file("policy.json")

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
