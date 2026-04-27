resource "aws_iam_user" "this" {
  name = var.name

  tags = {
    Name = var.name
  }
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid    = "AllowS3FullAccessExceptDelete"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:GetBucketAcl",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:ListBucketMultipartUploads",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }

  statement {
    sid    = "DenyAllDeleteActions"
    effect = "Deny"
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:DeleteBucketWebsite",
    ]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
}

resource "aws_iam_user_policy" "s3_access" {
  name   = "${var.name}-s3-access"
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.s3_access.json
}
