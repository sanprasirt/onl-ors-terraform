variable "aws_region" {
  description = "The region resource deployed"
  default     = "ap-southeast-1"
}

variable "vpc_id" {
  description = "The vpc id"
  default = "vpc-009cfbce83a5d53ae"
}

variable "aws_nonexpose_subnets" {
  description = "The list of private subnets ids"
  type        = list(string)
  default     = ["subnet-0428cfc77e0fb7c11", "subnet-069293c4a9172a514"]
}

variable "noneexpose_subnets_cidr_blocks" {
  description = "The list of noneexpose subnets cidr blocks"
  type        = list(string)
  default     = ["100.64.0.0/18", "100.64.64.0/18"]
}

variable "aws_secure_subnets" {
  description = "The list of private subnets ids"
  type        = list(string)
  default     = ["subnet-0b89c63a1ba9d97ec", "subnet-065b064361ebd65aa"]
}

variable "secure_subnets_cidr_blocks" {
  description = "The list of secure subnets cidr blocks"
  type        = list(string)
  default     = ["172.19.210.64/27", "172.19.210.96/27"]
}

variable "aws_app_subnets" {
  description = "The list of private subnets ids"
  type        = list(string)
  default     = ["subnet-0e09a12105bf3c5fa", "subnet-0b893adb932195bd3"]
}

variable "app_subnets_cidr_blocks" {
  description = "The list of app subnets cidr blocks"
  type        = list(string)
  default     = ["172.19.210.0/27", "172.19.210.32/27"]
}

variable "environment" {
  description = "The evironment of resource"
  type        = string
  default     = "uat"
}

variable "db_connection_string" {
  description = "DB Hostname"
  type        = string
  default     = "onl-ors-orsonl-stg.cd541tnsejm6.ap-southeast-1.rds.amazonaws.com:1521/ORSONL"
}

# variable "db_username" {
#   description = "DB User name"
#   type        = string
#   default     = "ors2user"
# }

# variable "db_password" {
#   description = "DB Password"
#   type        = string
#   sensitive   = true
# }
variable "repo_url" {
  description = "The url of ECR repository"
  type        = string
  default     = "802791533053.dkr.ecr.ap-southeast-1.amazonaws.com"
}