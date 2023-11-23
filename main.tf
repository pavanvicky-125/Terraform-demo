resource "aws_s3_bucket" "mybkt" {
    bucket = var.bucketname
  
}

resource "aws_s3_bucket_ownership_controls" "ownr" {
    bucket = aws_s3_bucket.mybkt.id

    rule {
      object_ownership = "BucketOwnerPreferred"
    }
  
}

resource "aws_s3_bucket_public_access_block" "pbc" {
    bucket = aws_s3_bucket.mybkt.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
  
}

resource "aws_s3_bucket_acl" "acl" {
    depends_on = [ 
        aws_s3_bucket_ownership_controls.ownr,
        aws_s3_bucket_public_access_block.pbc,
     ]

     bucket = aws_s3_bucket.mybkt.id
     acl = "public-read"
  
}

resource "aws_s3_object" "obj" {
    bucket = aws_s3_bucket.mybkt.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_object" "errobj" {
    bucket = aws_s3_bucket.mybkt.id
    key = "error.html"
    source = "error.html"
    acl = "public-read"
    content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
    bucket = aws_s3_bucket.mybkt.id
    index_document {
        suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
    depends_on = [ aws_s3_bucket_acl.acl ]
  
}
 
 resource "aws_s3_bucket_versioning" "bv" {
    bucket = aws_s3_bucket.mybkt.id
    versioning_configuration {
      status = "Enabled"
    }
   
 }