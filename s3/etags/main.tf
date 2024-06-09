terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" # Specify the AWS region
}

resource "aws_s3_bucket" "default" {
  bucket = "my-terraform-bucket-name-123456-ap" # Provide a unique bucket name
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.default.bucket
  key    = "myfile.txt"
  source = "myfile.txt" 
  etag = filemd5("myfile.txt")
}
