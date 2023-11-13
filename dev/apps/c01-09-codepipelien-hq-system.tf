resource "aws_codepipeline" "codepipeline_hq_system" {
  name     = "${local.prefix}-hq-system-${var.environment}-codepipeline"
  role_arn = var.code_pipeline_role

  artifact_store {
    location = "codepipeline-ap-southeast-1-915051222475"
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
        RepositoryName       = "onl-ors-hq-system"
      }
      input_artifacts  = []
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeCommit"
      region           = var.aws_region
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
      run_order        = 1
      version          = "1"
    }
  }

stage {
    name = "Deploy"
    action {
      category = "Deploy"
      configuration = {
        ClusterName = "onl-ors-ecs-cluster-dev"
        FileName    = "imagedefinitions.json"
        ServiceName = "onl-ors-hq-system-service"
      }
      input_artifacts  = ["BuildArtifact"]
      name             = "DeployDev"
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      region           = "ap-southeast-1"
      run_order        = 1
      version          = "1"
    }
  }
}

