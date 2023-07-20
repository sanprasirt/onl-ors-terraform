variable "aws_region" {
  description = "The region of aws"
  default     = "ap-southeast-1"
}

variable "create" {
  description = "Detrmind whether to create codebuild or not"
  type        = bool
  default     = true
}
variable "codebuild_environment" {
  type = map(string)
  default = {
    AWS_ACCOUNT_ID = "802791533053"
    AWS_REGION     = "ap-southeast-1"
  }
}
