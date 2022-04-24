resource "aws_lb_target_group" "app" {
  deregistration_delay = "30"

  health_check {
    enabled             = "true"
    interval            = "30"
    matcher             = "200"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "10"
    unhealthy_threshold = "3"
    healthy_threshold   = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.project}-${var.environment}"
  port                          = var.port
  protocol                      = "HTTP"
  slow_start                    = "120"
  target_type                   = "ip"
  vpc_id                        = aws_vpc.vpc.id

  lifecycle {
    create_before_destroy = true
  }
}