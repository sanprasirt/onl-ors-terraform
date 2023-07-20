variable "aws_region" {
  description = "The region of aws"
  default     = "ap-southeast-1"
}

variable "create_codebuild" {
  description = "Create codebuild"
  type        = bool
  default     = true
}

variable "codebuild" {
  type    = list(string)
  default = []
}


variable "environment" {
  type = map(string)
  default = {
    AWS_ACCOUNT_ID = "802791533053"
    AWS_REGION     = "ap-southeast-1"
  }
}
