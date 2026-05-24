The error message indicates that Terraform is trying to use an AWS SNS topic resource type which it does not support (`aws_sns_topics`). Instead of `"ai-sns-topic"`, you should be using a correct name for your Amazon Simple Notification Service Topic.

Here's the corrected HCL code: