resource "aws_s3_bucket" "my_s3" {
  bucket = "my-terraform-bucket-112001"
}


resource "aws_s3_bucket" "my_log_bucket" {
  bucket = "my-terraform-log-bucket-112001"
}

resource "aws_s3_bucket_logging" "my_s3_logging" {
  bucket        = aws_s3_bucket.my_s3.id
  target_bucket = aws_s3_bucket.my_log_bucket.id
  target_prefix = "log/"
}


data "aws_canonical_user_id" "log_delivery_canonical" {}

data "aws_iam_policy_document" "my_log_bucket_policy_doc" {
  statement {
    sid     = "AllowS3ServerAccessLogs"
    effect  = "Allow"

    principals {
      type        = "CanonicalUser"
      identifiers = [data.aws_canonical_user_id.log_delivery_canonical.id]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.my_log_bucket.arn}/*"
    ]
  }

  statement {
    sid     = "AllowALBLogs"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.my_log_bucket.arn}/*"
    ]
  }

  statement {
    sid     = "AllowALBGetBucketLocation"
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.my_log_bucket.arn
    ]
  }
}

resource "aws_s3_bucket_policy" "my_log_bucket_policy" {
  bucket = aws_s3_bucket.my_log_bucket.id
  policy = data.aws_iam_policy_document.my_log_bucket_policy_doc.json
}
