provider "aws" {
  region = "us-east-1"
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

resource "aws_s3_bucket" "sagemaker_data" {
  bucket = "sagemaker-data-bucket-free-tier"
  acl    = "private"
}

resource "aws_s3_bucket" "sagemaker_model_artifacts" {
  bucket = "sagemaker-model-artifacts-free-tier"
  acl    = "private"
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name              = "sagemaker-notebook-free-tier"
  instance_type     = "ml.t2.medium"  # Free tier eligible
  role_arn          = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_config.name
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lifecycle_config" {
  name = "sagemaker-lifecycle-config-free-tier"

  on_start = <<-EOF
    #!/bin/bash
    echo "Starting the SageMaker Notebook Instance"
  EOF

  on_create = <<-EOF
    #!/bin/bash
    echo "Creating the SageMaker Notebook Instance"
  EOF
}

resource "aws_lambda_function" "sagemaker_refresh" {
  filename         = "lambda/lambda_function.zip"
  function_name    = "sagemaker_refresh"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("lambda/lambda_function.zip")

  environment {
    variables = {
      SAGEMAKER_NOTEBOOK_INSTANCE_NAME = "sagemaker-notebook-free-tier"
    }
  }
}

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


