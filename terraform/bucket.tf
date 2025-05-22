# BUCKET 1

resource "aws_s3_bucket" "s3-in" {
  bucket = "technoinput-jakarta-ibrahimm"
}

resource "aws_s3_bucket_ownership_controls" "s3-in-ownr" {
  bucket = aws_s3_bucket.s3-in.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-in-pub-access" {
  bucket = aws_s3_bucket.s3-in.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3-in-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3-in-ownr,
    aws_s3_bucket_public_access_block.s3-in-pub-access,
  ]

  bucket = aws_s3_bucket.s3-in.id
  acl    = "public-read"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-in" {
  bucket = aws_s3_bucket.s3-in.id

  rule {
    id = "techno-s3-in-lifecycle"

    filter {
        prefix=""
    }

    transition {
        days = 30
        storage_class = "DEEP_ARCHIVE"
    }

    expiration {
        days = 365
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "s3-in-versioning" {
  bucket = aws_s3_bucket.s3-in.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3-in-policy-connect" {
  bucket = aws_s3_bucket.s3-in.id
  policy = data.aws_iam_policy_document.s3-in-policy-doc.json
}

data "aws_iam_policy_document" "s3-in-policy-doc" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["*"]
    effect = "Allow"

    resources = [
      aws_s3_bucket.s3-in.arn,
      "${aws_s3_bucket.s3-in.arn}/*",
    ]
  }
}


# BUCKET 2


resource "aws_s3_bucket" "s3-out" {
  bucket = "technooutput-jakarta-ibrahimm"
}

resource "aws_s3_bucket_ownership_controls" "s3-out-ownr" {
  bucket = aws_s3_bucket.s3-out.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-out-pub-access" {
  bucket = aws_s3_bucket.s3-out.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3-out-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3-out-ownr,
    aws_s3_bucket_public_access_block.s3-out-pub-access,
  ]

  bucket = aws_s3_bucket.s3-out.id
  acl    = "public-read"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-out" {
  bucket = aws_s3_bucket.s3-out.id

  rule {
    id = "techno-s3-out-lifecycle"

    filter {
        prefix=""
    }

    transition {
        days = 30
        storage_class = "DEEP_ARCHIVE"
    }

    expiration {
        days = 365
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "s3-out-versioning" {
  bucket = aws_s3_bucket.s3-out.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "s3-out-policy-connect" {
  bucket = aws_s3_bucket.s3-out.id
  policy = data.aws_iam_policy_document.s3-out-policy-doc.json
}

data "aws_iam_policy_document" "s3-out-policy-doc" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["*"]
    effect = "Allow"

    resources = [
      aws_s3_bucket.s3-out.arn,
      "${aws_s3_bucket.s3-out.arn}/*",
    ]
  }
}