
resource "aws_s3_bucket" "bucket_front_end" {
  bucket = "www.${var.bucket_name_front_end}"
  force_destroy=true
  
  # adding resource tags
  tags = var.tags
}


resource "aws_s3_bucket_acl" "bucket_front_end_acl" {
  bucket = aws_s3_bucket.bucket_front_end.id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.bucket_front_end_acl_ownership]


}


resource "aws_s3_bucket_ownership_controls" "bucket_front_end_acl_ownership" {
  bucket = aws_s3_bucket.bucket_front_end.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.bucket_front_end_public_access_block]

  
}



resource "aws_s3_bucket_public_access_block" "bucket_front_end_public_access_block" {
  bucket = aws_s3_bucket.bucket_front_end.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}




resource "aws_s3_bucket_cors_configuration" "bucket_front_end_cors_configuration" {
  bucket = aws_s3_bucket.bucket_front_end.bucket
  
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    #allowed_origins = ["https://www.${var.domain_name}"]
    allowed_origins=["*"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_policy" "bucket_front_end_policy" {
  bucket = aws_s3_bucket.bucket_front_end.id
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

  depends_on = [aws_s3_bucket_public_access_block.bucket_front_end_public_access_block]

  
}



resource "aws_s3_bucket_website_configuration" "website-config" {
  bucket = aws_s3_bucket.bucket_front_end.id

  index_document {
    suffix = "index.html"
  }
  
  error_document {
    key = "404.jpeg"
  }

}



/*


resource "aws_s3_object" "object-index_html" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "index.html"
    source          = "../../../${var.website_root}/index.html"
    content_type    = "text/html"
    etag            = filemd5("../../../${var.website_root}/index.html")
  
}

resource "aws_s3_object" "object-not-found" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "pages/not-found.html"
    source          = "../../../${var.website_root}/pages/not-found.html"
    content_type    = "text/html"
    etag            = filemd5("../../../${var.website_root}/pages/not-found.html")
  
}


resource "aws_s3_object" "object-submitted" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "pages/submitted.html"
    source          = "../../../${var.website_root}/pages/submitted.html"
    content_type    = "text/html"
    etag            = filemd5("../../../${var.website_root}/pages/submitted.html")
  
}




resource "aws_s3_object" "object-index_css" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "index.css"
    source          = "../../../${var.website_root}/index.css"
    content_type    = "text/css"
    etag            = filemd5("../../../${var.website_root}/index.css")
  
}



resource "aws_s3_object" "scripts_geolocation" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "scripts/geolocation.js"
    source          = "../../../${var.website_root}/scripts/geolocation.js"
    content_type    = "text/javascript"
    etag            = filemd5("../../../${var.website_root}/scripts/geolocation.js")
  
}


resource "aws_s3_object" "scripts_main" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "scripts/main.js"
    source          = "../../../${var.website_root}/scripts/main.js"
    content_type    = "text/javascript"
    etag            = filemd5("../../../${var.website_root}/scripts/main.js")
  
}


resource "aws_s3_object" "scripts_submit" {
    bucket          = aws_s3_bucket.bucket_front_end.id
    key             = "scripts/submit.js"
    source          = "../../../${var.website_root}/scripts/submit.js"
    content_type    = "text/javascript"
    etag            = filemd5("../../../${var.website_root}/scripts/submit.js")
  
}

*/
//cloudfront

/*
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

*/