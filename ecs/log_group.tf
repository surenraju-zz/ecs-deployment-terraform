resource "aws_cloudwatch_log_group" "awslogs-ecs" {
  name              = "awslogs-ecs"
  retention_in_days = 1

  tags = {
    Name = "awslogs-ecs"
    Environment = var.environment
    Project     = var.project
    Owner       = var.owner
  }
}