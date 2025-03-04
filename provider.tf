provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-12345"  # Change to a globally unique name
  force_destroy = true  # Deletes the bucket even if it contains objects
}
