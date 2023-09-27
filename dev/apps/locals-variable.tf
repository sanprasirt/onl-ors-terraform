locals {
  prefix = "onl-ors"
  common_tags = {
    Service     = "onl"
    System      = "ors"
    Owner       = "cpall"
    Environment = var.environment
    Createby    = "TechEx created by terraform"
    SR          = "-"
    Project     = "refactor"
  }
}