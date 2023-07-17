variable "mq_host_with_port" {
  description = "MQ Hostname"
  type        = string
  sensitive   = true
}

variable "mq_username" {
  description = "MQ User name"
  type        = string
  sensitive   = true
}

variable "mq_password" {
  description = "MQ Password"
  type        = string
  sensitive   = true
}

variable "mq_instance_types" {
  description = "The type of EC2 instance to launch"
  type        = map(string)
  default = {
    dev   = "mq.t3.micro"
    stage = "mq.m5.large"
    prod  = "mq.m5.xlarge"
  }
}

variable "engine_version" {
  description = "The version of the broker engine"
  type = string
  default = "3.10.20"
}