provider "aws" {
    region = "us-east-1" # Change this to your AWS Region, e.g., us-west-2 or ap-northeast-1 etc... 
}
resource "aws_sns_topic" "ai_sns_topic" {  
 name  = "ai-sns-topic"   
}
output "sns_topic_arn" { # Output the ARN of SNS Topic, not a resource type. This is for reference only and will be removed in future updates 
 value = aws_sns_topic.ai_sns_topic.arn   //This line should remain as it references an existing AWS Resource (aws_sns_topics) which has been declared beforehand by the user or a module that import this resource into their main Terraform configuration file 
}