############################################
#    cloudfront single page app buckets    #
############################################
# create the buckets
resource "aws_s3_bucket" "bucketAB" {
  for_each = toset(["A", "B"])
  bucket   = "${var.bucket_prefix}${var.environment}${each.key}"

  tags     = merge(var.tags, {
    Name            = "${var.bucket_prefix}${var.environment}${each.key}"
    Environment     = "${var.environment}"
    Lifecycle       = "0"
    KMSEncrypted    = "false"
  })
}

# create website config
resource "aws_s3_bucket_website_configuration" "bucketAB" {
  for_each = aws_s3_bucket.bucketAB
  bucket   = aws_s3_bucket.bucketAB[each.key].id
  index_document {
    suffix = var.index_file
  }
}

# associate s3 policy
resource "aws_s3_bucket_policy" "bucketAB" {
  for_each = aws_s3_bucket.bucketAB
  bucket = aws_s3_bucket.bucketAB[each.key].id
  policy = data.aws_iam_policy_document.bucketAB[each.key].json
}



############################################
# long-lived bucket of customer signatures #
############################################
# create the bucket
resource "aws_s3_bucket" "bucketC" {
  bucket = "${var.bucket_prefix}${var.environment}C"

  tags   = merge(var.tags, {
    Name            = "${var.bucket_prefix}${var.environment}C"
    Environment     = "${var.environment}"
    Lifecycle       = "0"
    KMSEncrypted    = "true"
  })
}

# since this is likely sensitive data, we'd want a kms key at minimum for security purposes
resource "aws_kms_key" "bucketC" {
  description = "KMS key for bucketC"
  deletion_window_in_days = 10
}

# associate the kms key 
resource "aws_s3_bucket_server_side_encryption_configuration" "bucketC" {
  bucket = aws_s3_bucket.bucketC.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucketC.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

/*
we would probably also want guardduty depending on whether this would be customer facing or not
Guardduty for s3 would need enabling on the account firstly, then a role for malware scanning would need creating
Then we'd want that guardduty malware scanning role allowed on the bucket policy
I've left it out of scope for now for simplicity sake.
*/

# associate s3 policy
resource "aws_s3_bucket_policy" "bucketC" {
  bucket = aws_s3_bucket.bucketC.id
  policy = data.aws_iam_policy_document.bucketC.json
}



############################################
#        48 hour lifecycle bucket          #
############################################
# create the bucket
resource "aws_s3_bucket" "bucketD" {
  bucket = "${var.bucket_prefix}${var.environment}D"

  tags   = merge(var.tags, {
    Name            = "${var.bucket_prefix}${var.environment}D"
    Environment     = "${var.environment}"
    Lifecycle       = "48"
    KMSEncrypted    = "false"
  })
}

# enable 48hr lifecycle rule
resource "aws_s3_bucket_lifecycle_configuration" "bucketD" {
  bucket = aws_s3_bucket.bucketD.id

  rule {
    id     = "48hr"
    status = "Enabled"
    expiration {
      days = 2
    }
  }
}

# associate s3 policy
resource "aws_s3_bucket_policy" "bucketD" {
  bucket = aws_s3_bucket.bucketD.id
  policy = data.aws_iam_policy_document.bucketD.json
}