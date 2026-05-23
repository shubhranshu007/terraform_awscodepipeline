provider "aws" {
  region = "us-east-1" # Change this to your region
}

resource "aws_sns_topics" "ai_sns_topic" {
  name = "ai-sns-topic"
}

output "sns_topic_arn" {
  value = aws_sns_topic.ai_sns_topic.arn
}
