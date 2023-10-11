
resource "aws_s3_bucket" "location-tracker-front-end" {
  bucket = "www.${var.bucket_name}"
  force_destroy=true
}


resource "aws_s3_bucket_acl" "bucket-acl" {
  bucket = aws_s3_bucket.location-tracker-front-end.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}


resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.location-tracker-front-end.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.example]
}



resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.location-tracker-front-end.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


#check https://stackoverflow.com/questions/12358173/correct-s3-cloudfront-cors-configuration
resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.location-tracker-front-end.bucket
cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    #allowed_origins = ["https://www.${var.domain_name}"]
    allowed_origins=["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.location-tracker-front-end.id
  policy = data.aws_iam_policy_document.iam-policy-1.json
}
data "aws_iam_policy_document" "iam-policy-1" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
resources = [
      "arn:aws:s3:::www.${var.domain_name}",
      "arn:aws:s3:::www.${var.domain_name}/*",
    ]
actions = ["S3:GetObject"]
principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.example]
}



resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.location-tracker-front-end.id
index_document {
    suffix = "index.html"
  }
error_document {
    key = "404.jpeg"
  }

}




#upload the index html
resource "aws_s3_object" "object-index_html" {
    bucket          = aws_s3_bucket.location-tracker-front-end.id
    key             = "index.html"
    source          = "../${var.website_root}/index.html"
    content_type    = "text/html"
    etag            = filemd5("../${var.website_root}/index.html")
  
}

#upload the "pages" folder
module "pages_folder" {
  source = "hashicorp/dir/template"
  base_dir = "../${var.website_root}/pages"
}

resource "aws_s3_bucket_object" "pages"{
  for_each=module.pages_folder.files
  bucket = aws_s3_bucket.location-tracker-front-end.id
  content_type    = "text/html"
  key="pages/${each.key}"
  source="../${var.website_root}/pages/${each.key}"
  etag   = filemd5("../${var.website_root}/pages/${each.key}")
}


#upload the assets folder
module "assets_folder" {
  source = "hashicorp/dir/template"
  base_dir = "../${var.website_root}/assets"
}

resource "aws_s3_bucket_object" "assets"{
  for_each=module.assets_folder.files
  bucket = aws_s3_bucket.location-tracker-front-end.id
  content_type    =each.value.content_type
  key="assets/${each.key}"
  source="../${var.website_root}/assets/${each.key}"
  etag   = filemd5("../${var.website_root}/assets/${each.key}")
}





#upload the "styles" folder
module "styles_folder" {
  source = "hashicorp/dir/template"
  base_dir = "../${var.website_root}/styles"
}

resource "aws_s3_bucket_object" "styles"{
  for_each=module.styles_folder.files
  bucket = aws_s3_bucket.location-tracker-front-end.id
  content_type    = "text/css"
  key="styles/${each.key}"
  source="../${var.website_root}/styles/${each.key}"
  etag   = filemd5("../${var.website_root}/styles/${each.key}")
}



#upload the "scripts" folder
module "scripts_folder" {
  source = "hashicorp/dir/template"
  base_dir = "../${var.website_root}/scripts"
}

resource "aws_s3_bucket_object" "scripts"{
  for_each=module.scripts_folder.files
  bucket = aws_s3_bucket.location-tracker-front-end.id
  content_type    = "text/javascript"
  key="scripts/${each.key}"
  source="../${var.website_root}/scripts/${each.key}"
  etag   = filemd5("../${var.website_root}/scripts/${each.key}")
}


#upload the "variables" folder
module "variables_folder" {
  source = "hashicorp/dir/template"
  base_dir = "../${var.website_root}/variables"
}

resource "aws_s3_bucket_object" "variables"{
  for_each=module.variables_folder.files
  bucket = aws_s3_bucket.location-tracker-front-end.id
  content_type    = "text/javascript"
  key="variables/${each.key}"
  source="../${var.website_root}/variables/${each.key}"
  etag   = filemd5("../${var.website_root}/variables/${each.key}")
}



//cloudfront


resource "aws_cloudfront_distribution" "cloud-front-s3" {
  
  enabled = true
  
  origin {
    origin_id                = "${var.bucket_name}-origin"
    domain_name              =  aws_s3_bucket.location-tracker-front-end.website_endpoint
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    
    target_origin_id = "${var.bucket_name}-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_200"
  depends_on =[aws_s3_bucket.location-tracker-front-end]
}