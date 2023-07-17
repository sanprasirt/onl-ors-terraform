################################################################################
# Cluster
# Provision ECS Cluster using ec2 autoscaling group  
################################################################################

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.0.1"

  # create = false

  cluster_name = "${local.prefix}-ecs-cluster-${var.environment}"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }
  # Capacity provider - autoscaling groups
  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {
    # On-demand instances
    asg-1 = {
      auto_scaling_group_arn         = module.autoscaling["asg-1"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 7
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 80
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = local.common_tags
}

################################################################################
# Service
################################################################################
/*
module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.0.1"

  # Service
  name        = local.name
  cluster_arn = module.ecs_cluster.arn

  # Task Definition
  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    # On-demand instances
    asg-1 = {
      capacity_provider = module.ecs_cluster.autoscaling_capacity_providers["asg-1"].name
      weight            = 1
      base              = 1
    }
  }

  volume = {
    my-vol = {}
  }

  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      image = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]

      mount_points = [
        {
          sourceVolume  = "my-vol",
          containerPath = "/var/www/my-vol"
        }
      ]

      entry_point = ["/usr/sbin/apache2", "-D", "FOREGROUND"]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false
    }
  }

  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_http_ingress = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb_sg.security_group_id
    }
  }

  tags = local.tags
}*/

################################################################################
# Supporting Resources
################################################################################

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux
data "aws_ssm_parameter" "ecs_optimized_ami" {
  # name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "alb-service-sg"
  description = "Service security group"
  vpc_id      = var.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = var.noneexpose_subnets_cidr_blocks


  tags = local.common_tags
}

# Create Application LoadBalancer

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${local.prefix}-alb-ecs-${var.environment}"

  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.aws_app_subnets
  security_groups    = [module.alb_sg.security_group_id]
  # access_logs = {
  #   bucket = "${local.prefix}-alb-logs"
  # }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      # target_group_index = 0
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "This path is not available"
        status_code  = "200"
      }
    },
  ]

  # HTTP Listener rules
  # http_tcp_listener_rules = [
  #   {
    
  #     http_listener_index = 0
  #     priority            = 99
  #     actions = [{
  #         type               = "forward"
  #         target_group_index = 0
  #       },
  #     ]
  #     conditions = [{
  #         path_patterns = ["/*"]
  #       },
  #     ]
  #   }
  # ]

  target_groups = [
    for idx, target_group in local.target_groups : {
      name             = target_group.name
      backend_protocol = target_group.backend_protocol
      backend_port     = target_group.backend_port
      target_type      = target_group.target_type
      health_check     = target_group.health_check
      tags = merge({
        Name = target_group.name },
        local.common_tags
      )
    }
  ]

  tags = merge({
    Name = "${local.prefix}-alb-ecs-${var.environment}" },
    local.common_tags
  )
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 6.5"
  for_each = {
    # On-demand instances
    asg-1 = {
      instance_type              = var.ecs_instance_types[var.environment]
      use_mixed_instances_policy = false
      mixed_instances_policy     = {}
      user_data                  = <<-EOT
        #!/bin/bash
        cat <<'EOF' >> /etc/ecs/ecs.config
        ECS_CLUSTER=${local.prefix}-ecs-cluster-${var.environment}
        ECS_LOGLEVEL=debug
        ECS_CONTAINER_INSTANCE_TAGS=${jsonencode(local.common_tags)}
        ECS_ENABLE_TASK_IAM_ROLE=true
        EOF
      EOT
    }
  }

  name = "${local.prefix}-ecs-cluster-${var.environment}-${each.key}"

  image_id                        = jsondecode(data.aws_ssm_parameter.ecs_optimized_ami.value)["image_id"]
  instance_type                   = each.value.instance_type
  key_name                        = "onlors-ecsdev"
  security_groups                 = [module.autoscaling_sg.security_group_id]
  user_data                       = base64encode(each.value.user_data)
  ignore_desired_capacity_changes = true

  create_iam_instance_profile = true
  iam_role_name               = "ecsInstanceRole"
  iam_role_description        = "ECS role for ${local.prefix}-ecs-cluster-${var.environment}"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
    AmazonSSMManagedInstanceCore        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  vpc_zone_identifier = var.aws_nonexpose_subnets
  health_check_type   = "EC2"
  min_size            = 1
  max_size            = 7
  desired_capacity    = 1

  # https://github.com/hashicorp/terraform-provider-aws/issues/12582
  autoscaling_group_tags = {
    AmazonECSManaged = true
  }

  # Required for  managed_termination_protection = "ENABLED"
  protect_from_scale_in     = true
  health_check_grace_period = 30
  # Spot instances
  # use_mixed_instances_policy = each.value.use_mixed_instances_policy
  # mixed_instances_policy     = each.value.mixed_instances_policy

  tags = merge(
    { Name = "${local.prefix}-asg-${var.environment}" },
    local.common_tags
  )
}

module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"


  name        = "${local.prefix}-asg-sg"
  description = "Autoscaling group security group"
  vpc_id      = var.vpc_id

  # ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules       = ["ssh-tcp"]
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.common_tags
}
