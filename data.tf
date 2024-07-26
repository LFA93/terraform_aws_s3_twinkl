# pull the s3 role arn
data "aws_iam_role" "s3_role" {
  name = var.role_name
}

data "aws_iam_role" "admin_role" {
  name = var.admin_role
}

/*
everything except KMS in AWS has a allow all by default type of policy
as such I like to create policies that deny unless rather than explicitly allow as a best practice
Admittedly, it does make policies harder to read but it ensures a security first approach
*/

# bucket A and B policies
data "aws_iam_policy_document" "bucketAB" {
  for_each = aws_s3_bucket.bucketAB
  # allow specific role to access bucket
  statement {
    sid       = "DenyUnless${var.role_name}"
    effect    = "Deny"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.bucketAB[each.key].arn}/*",
      "${aws_s3_bucket.bucketAB[each.key].arn}"
    ]
    # you can't seem to write a NotPrincipal statement in terraform annoyingly so using a condition instead
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.role.arn
      ]
    }
  }
  # since it's web, deny unless https/tls 1.2
  statement {
    sid       = "DenyUnlessTLS1.2"
    effect    = "Deny"
    actions   = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.bucketAB[each.key].arn}/*",
      "${aws_s3_bucket.bucketAB[each.key].arn}"
    ]
    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = [
        "1.2"
      ]
    }
  }
  # lastly deny policy edits and bucket deletion unless an admin role 
  # (the terraform role will also need adding if not running this as var.admin_role)
  statement {
    sid       = "DenyPolicyEditAndDeleteUnlessAdminRole"
    effect    = "Deny"
    actions   = [
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucket"
    ]
    resources = [
      "${aws_s3_bucket.bucketAB[each.key].arn}/*",
      "${aws_s3_bucket.bucketAB[each.key].arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.admin_role.arn
      ]
    }
  }
}

# bucket C policy
data "aws_iam_policy_document" "bucketC" {
  # allow specific role to access bucket
  statement {
    sid       = "DenyUnless${var.role_name}"
    effect    = "Deny"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.bucketC.arn}/*",
      "${aws_s3_bucket.bucketC.arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.role.arn
      ]
    }
  }
  # since it's sensitive data, deny unless encrypted. This should inheritenly be enforced anyway I believe
  statement {
    sid       = "DenyUnlessEncrypted"
    effect    = "Deny"
    actions   = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.bucketC.arn}/*",
      "${aws_s3_bucket.bucketC.arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = [
        "aws:kms"
      ]
    }
  }
  # lastly deny policy edits and bucket deletion unless an admin role
  # (the terraform role will also need adding if not running this as var.admin_role)
  statement {
    sid       = "DenyPolicyEditAndDeleteUnlessAdminRole"
    effect    = "Deny"
    actions   = [
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucket"
    ]
    resources = [
      "${aws_s3_bucket.bucketC.arn}/*",
      "${aws_s3_bucket.bucketC.arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.admin_role.arn
      ]
    }
  }
}

# bucket D policy
data "aws_iam_policy_document" "bucketD" {
  # allow specific role to access bucket
  statement {
    sid       = "DenyUnless${var.role_name}"
    effect    = "Deny"
    actions   = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.bucketD.arn}/*",
      "${aws_s3_bucket.bucketD.arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.role.arn
      ]
    }
  }
  # deny policy edits and bucket deletion unless an admin role
  # (the terraform role will also need adding if not running this as var.admin_role)
  statement {
    sid       = "DenyPolicyEditAndDeleteUnlessAdminRole"
    effect    = "Deny"
    actions   = [
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPolicy",
      "s3:DeleteBucket"
    ]
    resources = [
      "${aws_s3_bucket.bucketD.arn}/*",
      "${aws_s3_bucket.bucketD.arn}"
    ]
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = [
        data.aws_iam_role.admin_role.arn
      ]
    }
  }
}