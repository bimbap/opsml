resource "aws_glue_catalog_database" "gluedb" {
  name = "rekognition_results_db"
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "rekognition_results_table"
  database_name = aws_glue_catalog_database.gluedb.name
}

resource "aws_glue_crawler" "gluecraw" {
  database_name = aws_glue_catalog_database.gluedb.name
  schedule      = "cron(1 * * * ? *)"
  name          = "techno-crawler-ibrahim"
  role          = "arn:aws:iam::437248787701:role/LabRole"

  configuration = jsonencode(
    {
      Grouping = {
        TableGroupingPolicy = "CombineCompatibleSchemas"
      }
      CrawlerOutput = {
        Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
      }
      Version = 1
    }
  )

  s3_target {
    path = "s3://${aws_s3_bucket.s3-out.bucket}"
  }
}