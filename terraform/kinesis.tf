
resource "aws_kinesis_stream" "kinesis" {
  name        = "techno-kinesis-ibrahim"
  shard_count = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}


resource "aws_dynamodb_kinesis_streaming_destination" "kinesis-dest" {
  stream_arn                               = aws_kinesis_stream.kinesis.arn
  table_name                               = aws_dynamodb_table.dydb.name
  approximate_creation_date_time_precision = "MICROSECOND"
}