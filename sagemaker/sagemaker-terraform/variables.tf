variable "region" {
  default = "us-east-1"
}

variable "sagemaker_instance_type" {
  default = "ml.t2.medium"
}

variable "sagemaker_role_arn" {
  description = "The ARN of the SageMaker execution role"
}