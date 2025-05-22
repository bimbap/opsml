resource "aws_athena_database" "athena-db" {
  name   = "techno_athena_db"
  bucket = aws_s3_bucket.s3-out.id
}

resource "aws_athena_workgroup" "athena-workgroup" {
  name = "techno-athena-query"

  configuration {
    enforce_workgroup_configuration = true
    publish_cloudwatch_metrics_enabled = true

  result_configuration {
    output_location = "s3://${aws_s3_bucket.s3-out.bucket}/output/"

    }
  }
}

resource "aws_athena_named_query" "athena-query" {
  name      = "techno-query"
  database  = aws_athena_database.athena-db.name
  workgroup = aws_athena_workgroup.athena-workgroup.id

  query     = <<SQL
    CREATE EXTERNAL TABLE IF NOT EXISTS rekognition_results_db.rekognition_results_table (
    image_key string,
    labels array<struct<Name:string, Confidence:double>>
    )
    ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
    WITH SERDEPROPERTIES (
    'serialization.format' = '1'
    )
    LOCATION 's3://technooutput-jakarta-ibrahimm/results'
    TBLPROPERTIES ('has_encrypted_data'='false');
  SQL
}
