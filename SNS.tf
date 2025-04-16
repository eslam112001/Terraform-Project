resource "aws_sns_topic" "my_sns" {
  name = "user-updates-topic"
}


resource "aws_sns_topic_subscription" "my_sns_subscription" {
  topic_arn = aws_sns_topic.my_sns.arn
  protocol  = "email"
  endpoint  = "eslamfarag577@gmail.com"
}