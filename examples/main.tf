module "codebuild" {
  source           = "../modules/code-pipeline"
  aws_region       = "ap-southeast-1"
  create = true
  codebuild_environment = {
    AWS_ACCOUNT_ID = "802791533053"
    AWS_REGION     = "ap-southeast-1"
  }
}
