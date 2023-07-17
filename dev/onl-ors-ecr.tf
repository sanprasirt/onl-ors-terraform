# aws_ecr_repository.onl-ors-reserve:

locals {
  ecr_repos = [
    "onl-ors-reserve",
    "onl-ors-receive",
    "onl-ors-cancel",
    "onl-ors-search",
    "onl-ors-confirm",
    "onl-ors-webapp",
    "onl-ors-mq-consume",
    "onl-ors-mq-consume-product",
    "onl-ors-webmonitor",
    "onl-ors-printscreport",
    "onl-ors-screport"
  ]
}
resource "aws_ecr_repository" "onl-ors-reserve" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-reserve"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-receive" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-receive"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-cancel" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-cancel"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-search" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-search"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-confirm" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-confirm"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_ecr_repository" "onl-ors-webapp" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-webapp"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_ecr_repository" "onl-ors-mq-consume" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-mq-consume"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-mq-consume-product" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-mq-consume-product"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-webmonitor" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-webmonitor"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-printscreport" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-printscreport"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_ecr_repository" "onl-ors-screport" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-screport"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}