resource "aws_dynamodb_table" "dydb" {
  name             = "Tokens"
  hash_key         = "token"
  billing_mode     = "PAY_PER_REQUEST"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "token"
    type = "S"
  }
}