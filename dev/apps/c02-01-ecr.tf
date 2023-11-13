resource "aws_ecr_repository" "onl-ors-checklot" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-checklot"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_repository" "onl-ors-hq-system" {
  image_tag_mutability = "MUTABLE"
  name                 = "${local.prefix}-hq-system"
  tags                 = local.common_tags


  image_scanning_configuration {
    scan_on_push = false
  }
  lifecycle {
    create_before_destroy = true
  }
}