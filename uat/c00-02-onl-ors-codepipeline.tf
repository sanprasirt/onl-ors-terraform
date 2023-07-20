resource "aws_codepipeline" "codepipeline" {
  name     = "onl-ors-reserve-uat-codepipeline"
  role_arn = "arn:aws:iam::802791533053:role/service-role/Onl-Ors-AWSCodePipelineServiceRole"
  artifact_store {
    location = "codepipeline-ap-southeast-1-915051222475"
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
        name            = "Source"
        category        = "Source"
        owner           = "AWS"
        provider        = "CodeCommit"
        version         = "1"
        output_artifacts = ["SourceArtifact"]
        region = "ap-southeast-1"
        configuration = {
            RepositoryName = "onl-ors-reserve-uat"
            BranchName     = "uat"
            OutputArtifactFormat   = "CODE_ZIP"
        }
    }
  }
  
  stage {
    name = "Build"
    action {
      name = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
      region = "ap-southeast-1"
      configuration = {
        ProjectName = "onl-ors-reserve-uat"
      }
    }
  }
}
