provider "aws" {
    region = "us-east-1" # Change this to your AWS Region, e.g., us-west-2 or ap-northeast-1 etc... 
}
resource "aws_sns_topic" "ai_sns_topic" {  
 name  = "ai-sns-topic"   
}
