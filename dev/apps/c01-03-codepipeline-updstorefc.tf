resource "aws_codepipeline" "codepipeline-updstorefc" {
  name     = "onl-ors-updstorefc-${var.environment}-codepipeline"
  role_arn = var.code_pipeline_role
  tags     = {}
  tags_all = {}
  artifact_store {
    location = "codepipeline-ap-southeast-1-915051222475"
    region   = null
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category = "Source"
      configuration = {
        BranchName           = "development"
        OutputArtifactFormat = "CODE_ZIP"
        PollForSourceChanges = "false"
        RepositoryName       = "onl-ors-updstorefc"
      }
      input_artifacts  = []
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeCommit"
      region           = var.aws_region
      role_arn         = null
      run_order        = 1
      version          = "1"
    }
  }
  stage {
    name = "Build"
    action {
      category = "Build"
      configuration = {
        ProjectName = "onl-ors-build"
      }
      input_artifacts  = ["SourceArtifact"]
      name             = "Build"
      namespace        = "BuildVariables"
      output_artifacts = ["BuildArtifact"]
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = var.aws_region
      role_arn         = null
      run_order        = 1
      version          = "1"
    }
  }
}
