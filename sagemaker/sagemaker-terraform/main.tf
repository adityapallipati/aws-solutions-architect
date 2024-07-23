provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Security Group
resource "aws_security_group" "sagemaker_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sagemaker.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ],
  })
}

resource "aws_iam_role_policy" "sagemaker_execution_policy" {
  name   = "sagemaker_execution_policy"
  role   = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "logs:*",
          "cloudwatch:*"
        ],
        Resource = "*"
      },
    ],
  })
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ],
  })
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  name   = "lambda_execution_policy"
  role   = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:*",
          "s3:*",
          "sagemaker:*",
          "ec2:DescribeImages"
        ],
        Resource = "*"
      },
    ],
  })
}

# S3 Buckets
resource "aws_s3_bucket" "sagemaker_data" {
  bucket = "sagemaker-data-bucket-free-tier"
  acl    = "private"
}

resource "aws_s3_bucket" "sagemaker_model_artifacts" {
  bucket = "sagemaker-model-artifacts-free-tier"
  acl    = "private"
}

# SageMaker Notebook Instance
resource "aws_sagemaker_notebook_instance" "notebook" {
  name              = "sagemaker-notebook-free-tier"
  instance_type     = "ml.t2.medium"  # Free tier eligible
  role_arn          = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_config.name
  subnet_id         = aws_subnet.main.id
  security_groups   = [aws_security_group.sagemaker_sg.id]
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lifecycle_config" {
  name = "sagemaker-lifecycle-config-free-tier"

  on_start = base64encode(<<-EOF
    #!/bin/bash
    echo "Starting the SageMaker Notebook Instance"
  EOF
  )

  on_create = base64encode(<<-EOF
    #!/bin/bash
    echo "Creating the SageMaker Notebook Instance"
  EOF
  )
}

# Lambda Function
resource "aws_lambda_function" "sagemaker_refresh" {
  filename         = "lambda/lambda_function.zip"
  function_name    = "sagemaker_refresh"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("lambda/lambda_function.zip")

  environment {
    variables = {
      SAGEMAKER_NOTEBOOK_INSTANCE_NAME = aws_sagemaker_notebook_instance.notebook.name
      SAGEMAKER_EXECUTION_ROLE_ARN     = aws_iam_role.sagemaker_execution_role.arn
      SUBNET_ID                        = aws_subnet.main.id
      SECURITY_GROUP_ID                = aws_security_group.sagemaker_sg.id
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.main.id]
    security_group_ids = [aws_security_group.sagemaker_sg.id]
  }
}

# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "thirty_day_rule" {
  name        = "thirty-day-rule"
  description = "Trigger Lambda every 30 days"
  schedule_expression = "rate(30 days)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.thirty_day_rule.name
  target_id = "sagemaker-instance-refresh"
  arn       = aws_lambda_function.sagemaker_refresh.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sagemaker_refresh.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.thirty_day_rule.arn
}