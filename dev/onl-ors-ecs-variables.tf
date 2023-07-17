variable "ecs_instance_types" {
  description = "The type of EC2 instance to launch"
  type        = map(string)
  default = {
    dev   = "t3.small"
    stage = "c5.xlarge"
    prod  = "m4.large"
  }
}

variable "services_name" {
  description = "Define Tasks for the name of service"
  type        = map(any)
  default = {
    webapp = {
      port          = 8080,
      variable_port = "8080",
      cpu           = 256,
      memory        = 512,
    },
    reserve = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    search = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    receive = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    confirm = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    cancel = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    mq-consume = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    mq-consume-product = {
      port          = 3000,
      variable_port = "3000",
      cpu           = 256,
      memory        = 512,
    },
    webmonitor = {
      port          = 8080,
      variable_port = "8080",
      cpu           = 256,
      memory        = 512,
    },
    printscreport = {
      port          = 8080,
      variable_port = "8080",
      cpu           = 256,
      memory        = 512,
    },
    screport = {
      port          = 8080,
      variable_port = "8080",
      cpu           = 256,
      memory        = 512,
    },
  }
}