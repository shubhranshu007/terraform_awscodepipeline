provider "aws" {
    region = "us-east-1" 
}
resource "aws_sns_topic" "ai_sns_topic" {  
 name  = "ai-sns-topic"   
}
