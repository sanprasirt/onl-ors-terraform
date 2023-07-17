
variable "redis_username" {
  description = "Redis User name"
  type        = string
  sensitive   = true
}
variable "redis_password" {
  description = "Redis Password"
  type        = string
  sensitive   = true
}

variable "cache_instance_types" {
  description = "The type of EC2 instance to launch"
  type        = map(string)
  default = {
    dev   = "cache.t4g.micro"
    stage = "cache.r6g.large"
    prod  = "cache.r6g.xlarge"
  }
}