# AWS Sagemaker

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

```sh
cd lambda
zip lambda_function.zip lambda_function.py
mv lambda_function.zip ..
```

## Step 1: Basic Directory Structure

```md
sagemaker-terraform/
|--- main.tf
|--- variables.tf
|--- outputs.tf
|--- lambda/
|     |__ lambda_function.py
```

- main.tf: main terraform configuration file
- variables.tf: file to define input variables
- outputs.tf: file to define output variables
- lambda/lambda_function.py: directory and file for the lambda function code

## Step 2: Provider Configuration (main.tf)

Set up the AWS provider in main.tf

```hcl
provider "aws" {
    region = "us-east-1"
}
```

## Step 3: IAM Roles and Policies (main.tf)

Create IAM roles and policies required for SageMaker and Lambda.

```hcl
resource = "aws_iam_role" "sagemaker_execution_role" {
    name = "sagemaker_execution_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17".
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

resource = "aws_iam_role_policy" "sagemaker_execution_policy" {
    name = "sagemaker_execution_policy"
    role = aws_iam_role.sagemaker_execution_role.id

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

resource = "aws_iam_role" "lambda_execution_role" {
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
    name = "lambda_execution_policy"
    role = aws_iam_role.lambda_execution_role.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow"
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
```

## Step 4: S3 Buckets (main.tf)

Create S3 buckets for storing data and model artifacts.

```hcl
resource "aws_s3_bucket" "sagemaker_data" {
    bucket = "sagemaker-data-bucket-free-tier"
    acl = "private"
}

resource "aws_s3_bucket" "sagemaker_model_artifacts" {
    bucket = "sagemaker-model-artifacts-free-tier"
    acl = "private"
}
```

## Step 5: SageMaker Notebook Instance (main.tf)

Create a SageMaker Notebook instance.

```hcl
resource "aws_sage_maker_notebook_instance "notebook" {
    name = "sagemaker-notebook-free-tier"
    instance_type = "ml.t2.medium" # Free tier eligible
    role_arn = aws_iam_role.sagemaker_execution_role.arn
    lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lifecycle_config.name
}

resource "aws_sage_maker_notebook_instance_lifecycle_configuration" "lifecycle_configuration" {
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
```

## Step 6: Lambda Function (lambda/lambda_function.py)

Create the Lambda function code to destroy and recreate the SageMaker instance.

```py
import boto3

def lambda_handler(event, context):
    sagemaker_client = boto3.client('sagemaker')
    ec2_client = boto3.client('ec2')

    # Stop and delete the existing SageMaker Notebook instance
    notebook_instance_name = "sagemaker-notebook-free-tier"
    sagemaker_client.stop_notebook_instance(NotebookInstanceName=notebook_instance_name)
    sagemaker_client.delete_notebook_instance(NotebookInstanceName=notebook_instance_name)

    # Find the latest Amazon Linux AMI
    response = ec2_client.describe_images(
        Filters=[
            {'Name': 'name', 'Values': ['amzn2-ami-hvm-2.0.*-x86_64-gp2']},
            {'Name': 'state', 'Values': ['available']}
        ],
        Owners=['amazon']
        SortBy='CreationDate'
        SortOrder='desc'
    )

    latest_ami = response['Images'][0]['ImageId']

    # Create a new SageMaker Notebook instance with the latest AMI
    sagemaker_client.create_notebook_instance(
        NotebookInstanceName=notebook_instance_name,
        InstanceType='ml.t2.medium',
        RoleArn='<YOUR-SAGEMAKER-EXECUTION-ROLE-ARN>',
        SubnetId='<YOUR-SUBNET-ID>',
        SecurityGroupIds=['<YOUR-SECURITY-GROUP-ID>']
        VolumeSizeInGB=5,
        DirectInternetAccess='Enabled',
        RootAccess='Enabled',
        LifecycleConfigName='sagemaker-lifecycle-config-free-tier'
    )

    return {
        'statusCode': 200,
        'body': f"Notebook instance {notebook_instance_name} refreshed with latest AMI {latest_ami}."
    }
```

## Step 7: Lambda Function Deployment (main.tf)

Deploy the Lambda function using Terraform

```hcl
resource = "aws_lambda_function" "sagemaker_refresh" {
    filename = "lambda/lambda_function.zip"
    function_name = "sagemaker_refresh"
    role = " aws_iam_role.lambda_execution_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
    source_code_hash = filebase64sha256("lambda/lambda_function.zip")

    environment {
        variables = {
            SAGEMAKER_NOTEBOOK_INSTANCE_NAME = "sagemaker-notebook-free-tier"
        }
    }
}
```

## Step 8: CloudWatch Event Rule (main.tf)

Create a CloudWatch Event rule to trigger the Lambda function every 30 days.

```hcl
resource "aws_cloudwatch_event_rule" "thirty_day_rule" {
    name = "thirty-day-rule"
    description = "Trigger Lambda every 30 days"
    schedule_expression = "rate(30 days)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.thirty_day_rule.name
    target_id = "sagemaker-instance-refresh"
    arn = "aws_lambda_function.sagemaker_refresh.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.sagemaker_refresh.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.thirty_day_rule.arn
}
```

## Step 9: Variables and Outputs (variables.tf and outputs.tf)

variables.tf
```hcl
variable "region" {
    default = "us-east-1"
}

variable "sagemaker_instance_type" {
    default = "ml.t2.medium"
}

variable "sagemaker_role_arn" {
    description = "The ARN of the SageMaker execution role"
}
```

outputs.tf
```hcl
output "sagemaker_notebook_instance_name" {
    value = aws_sagemaker_notebook_instance.notebook.name
}

output "sagemaker_notebook_instance_arn" {
    value = aws_sagemaker_notebook_instance.notebook.arn
}
```

## Step 10: Initialize and Apply Terraform

- navigate to your project dir: 

```sh
cd sagemaker-terraform

```
- initialize terraform: 

```sh
terraform init
```

- apply the configuration

```sh
terraform apply
```

