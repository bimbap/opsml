resource "aws_sns_topic" "sns-topic" {
  name            = "techno-sns-jakarta-ibrahim"
}

resource "aws_sns_topic_subscription" "sns-topic-subs" {
  topic_arn            = "arn:aws:sns:us-east-1:437248787701:techno-sns-jakarta-ibrahim"
  protocol             = "email"
  endpoint             = "handi@seamolec.org"
}