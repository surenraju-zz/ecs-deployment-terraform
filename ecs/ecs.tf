resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.environment}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  capacity_providers = ["FARGATE"]

  
}

resource "aws_ecs_service" "service" {
  name                               = "${var.project}-${var.environment}"
  cluster                            = aws_ecs_cluster.cluster.id
  desired_count                      = var.replicas
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  platform_version                   = var.platform_version
  task_definition                    = aws_ecs_task_definition.app.arn
  scheduling_strategy                = "REPLICA"
  launch_type                        = "FARGATE"
  enable_ecs_managed_tags            = false
  enable_execute_command             = true
  wait_for_steady_state              = true

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "${var.project}-${var.environment}"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.app.arn
  }

  network_configuration {
    assign_public_ip = "false"
    security_groups  = [aws_security_group.private-security-group.id]
    subnets          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id]
  }


  depends_on = [
    aws_ecs_task_definition.app,
    aws_lb.lb
  ]
}

resource "aws_ecs_task_definition" "app" {
  execution_role_arn       = aws_iam_role.task.arn
  family                   = "${var.project}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = jsonencode([
    {
      name  = "${var.project}-${var.environment}"
      image = "apache/nifi:1.16.0"
      logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group         = aws_cloudwatch_log_group.awslogs-ecs.name,
                    awslogs-region        = var.region
                    awslogs-stream-prefix = "nifi"
                }
            }
      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
            sourceVolume = "nifi-state",
            containerPath = "/opt/nifi/nifi-current/state",
            readOnly: false
        },
        {
            sourceVolume = "nifi-database-repository",
            containerPath = "/opt/nifi/nifi-current/database_repository",
            readOnly: false
        },

        {
            sourceVolume = "nifi-flowfile-repository",
            containerPath = "/opt/nifi/nifi-current/flowfile_repository",
            readOnly: false
        },
        {
            sourceVolume = "nifi-content-repository",
            containerPath = "/opt/nifi/nifi-current/content_repository",
            readOnly: false
        },
        {
            sourceVolume = "nifi-provenance-repository",
            containerPath = "/opt/nifi/nifi-current/provenance_repository",
            readOnly: false
        }
      ]
      essential = true
      environment : local.app_definitions
    }
    ]
  )

  volume {
    name = "nifi-state"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/opt/nifi/nifi-current/state"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.nifi-state.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "nifi-database-repository"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/opt/nifi/nifi-current/database_repository"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.nifi-database-repository.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "nifi-flowfile-repository"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/opt/nifi/nifi-current/flowfile_repository"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.nifi-flowfile-repository.id
        iam             = "ENABLED"
      }
    }
  }

    volume {
    name = "nifi-content-repository"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/opt/nifi/nifi-current/content_repository"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.nifi-content-repository.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name = "nifi-provenance-repository"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.efs.id
      root_directory     = "/opt/nifi/nifi-current/provenance_repository"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.nifi-provenance-repository.id
        iam             = "ENABLED"
      }
    }
  }

  depends_on = [
    aws_efs_file_system.efs,
    aws_efs_access_point.nifi-state,
    aws_efs_access_point.nifi-database-repository,
    aws_efs_access_point.nifi-flowfile-repository,
    aws_efs_access_point.nifi-content-repository,
    aws_efs_access_point.nifi-provenance-repository
  ]
}

locals {
  app_definitions = flatten([
    for k, v in var.app_definitions : [
      {
        name  = k
        value = v
      }
    ]
  ])
}
