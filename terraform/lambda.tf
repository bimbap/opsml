# LAMBDA-GET
data "archive_file" "archive-get" {
  type        = "zip"
  source_file = "../lambda/src/get/lambda_get.py"
  output_path = "techno_get.zip"
}

resource "aws_lambda_function" "get-lambda" {
  filename      = "techno_get.zip"
  function_name = "techno-lambda-get"
  role          = "arn:aws:iam::437248787701:role/LabRole"
  handler       = "index.test"
  timeout       = 90

  source_code_hash = data.archive_file.archive-get.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      TOKEN_TABLE = "Tokens"
    }
  }

  vpc_config {
    subnet_ids  = [aws_subnet.sb-priate-1a.id, aws_subnet.sb-priate-1b.id]
    security_group_ids = [aws_security_group.apps-sg.id, aws_security_group.lb-sg.id]
  }
}


# LAMBDA-POST
data "archive_file" "archive-post" {
  type        = "zip"
  source_file = "../lambda/src/post/lambda_post.py"
  output_path = "techno_post.zip"
}

resource "aws_lambda_function" "post-lambda" {
  filename      = "techno_post.zip"
  function_name = "techno-lambda-post"
  role          = "arn:aws:iam::437248787701:role/LabRole"
  handler       = "index.test"
  timeout       = 60

  source_code_hash = data.archive_file.archive-post.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      TOKEN_TABLE = "Tokens"
    }
  }

  vpc_config {
    subnet_ids  = [aws_subnet.sb-priate-1a.id, aws_subnet.sb-priate-1b.id]
    security_group_ids = [aws_security_group.apps-sg.id, aws_security_group.lb-sg.id]
  }
}

# LAMBDA-S3
data "archive_file" "archive-s3" {
  type        = "zip"
  source_file = "../lambda/src/s3/lambda_s3.py"
  output_path = "techno_s3.zip"
}

resource "aws_lambda_function" "s3-lambda" {
  filename      = "techno_s3.zip"
  function_name = "techno-lambda-s3"
  role          = "arn:aws:iam::437248787701:role/LabRole"
  handler       = "index.test"
  timeout       = 120

  source_code_hash = data.archive_file.archive-s3.output_base64sha256

  runtime = "python3.13"

  environment {
    variables = {
      SNS_TOPIC_ARN = "arn:aws:sns:us-east-1:437248787701:techno-sns-jakarta-ibrahim"
      KINESIS_STREAM_NAME = "techno-kinesis-ibrahim"
      DEST_BUCKET = "s3://technooutput-jakarta-ibrahimm/"
    }
  }

  vpc_config {
    subnet_ids  = [aws_subnet.sb-priate-1a.id, aws_subnet.sb-priate-1b.id]
    security_group_ids = [aws_security_group.apps-sg.id, aws_security_group.lb-sg.id]
  }
}

resource "aws_s3_bucket_notification" "s3-trigger-lambda" { 
  bucket = aws_s3_bucket.s3-out.id
  lambda_function { 
    lambda_function_arn = aws_lambda_function.s3-lambda.arn 
    events = ["s3:ObjectCreated:*"]
    }
}
