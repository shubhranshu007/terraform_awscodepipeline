provider "aws" {
  region = "ap-south-1" # Change this to your region
}

# S3 Bucket for Storing Source Code
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "my-cicd-pipeline-bucket-wtwdcvg-fvajhb" # Change this to a unique name
}

# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "CodePipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for CodePipeline
resource "aws_iam_policy" "codepipeline_policy" {
  name        = "CodePipelinePolicy"
  description = "Policy for CodePipeline access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["codedeploy:*"]
        Resource = "*"
      }
    ]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attach" {
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  role       = aws_iam_role.codepipeline_role.name
}

# AWS CodeBuild Project
resource "aws_codebuild_project" "build_project" {
  name          = "MyBuildProject"
  service_role  = aws_iam_role.codepipeline_role.arn
  build_timeout = 5

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "S3"
    location  = "${aws_s3_bucket.codepipeline_bucket.id}/source.zip"
  }
}

# AWS CodeDeploy Application
resource "aws_codedeploy_app" "deploy_app" {
  name = "MyCodeDeployApp"
}

# AWS CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "deploy_group" {
  app_name              = aws_codedeploy_app.deploy_app.name
  deployment_group_name = "MyDeploymentGroup"
  service_role_arn      = aws_iam_role.codepipeline_role.arn
}

# AWS CodePipeline
resource "aws_codepipeline" "cicd_pipeline" {
  name     = "MyCICDPipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "S3Source"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"

      configuration = {
        S3Bucket             = aws_s3_bucket.codepipeline_bucket.bucket
        S3ObjectKey          = "source.zip"
        PollForSourceChanges = "true"
      }

      output_artifacts = ["SourceOutput"]
    }
  }

  stage {
    name = "Build"

    action {
      name     = "CodeBuild"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }

      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "CodeDeploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeploy"
      version  = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.deploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deploy_group.deployment_group_name
      }

      input_artifacts = ["BuildOutput"]
    }
  }
}
