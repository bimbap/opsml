resource "aws_athena_database" "example" {
  name   = "database_name"
  bucket = aws_s3_bucket.example.id
}