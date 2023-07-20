module "codebuild" {
  source           = "../modules/code-pipeline"
  aws_region       = "ap-southeast-1"
  create_codebuild = false
  codebuild        = [""]
}
